import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart' show rootBundle;

import 'package:amigotools/config/services/DatabaseConfig.dart';

class DatabaseConnector extends Disposable
{
  late final Database context;

  Future<void> init({required bool initSchema}) async
  {
    if (initSchema)
    {
      context = await openDatabase(
        path.join(await getDatabasesPath(), DatabaseConfig.DefaultFileName),
        version: DatabaseConfig.SchemaVersion,
        onCreate: _onCreateSchema,
        onUpgrade: _onUpgradeDowngradeSchema,
        onDowngrade: _onUpgradeDowngradeSchema,
      );
    }
    else
    {
      context = await openDatabase(
        path.join(await getDatabasesPath(), DatabaseConfig.DefaultFileName),
      );
    }
  }

  @override
  FutureOr onDispose() async
  {
    await context.close();
  }

  Future<void> _onCreateSchema(Database db, int version) async
  {
    await _onUpgradeDowngradeSchema(db, 0, version);
  }

  Future<void> _onUpgradeDowngradeSchema(Database db, int oldVersion, int newVersion) async
  {
    final isUpgrade = oldVersion < newVersion;

    if (!isUpgrade)
    {
      oldVersion++;
      newVersion++;
    }

    var version = oldVersion;

    final batch = db.batch();

    do
    {
      version += isUpgrade ? 1 : -1;

      final filename = DatabaseConfig.MigrationFiles[version - 1];
      final filepath = path.join(DatabaseConfig.MigrationFilesPath, filename);

      await _executeSqlFile(batch, filepath, downgradePart: !isUpgrade);

    } while (version != newVersion);

    await batch.commit();
  }

  Future<void> _executeSqlFile(Batch batch, String filepath, {bool downgradePart = false}) async
  {
    final script = await rootBundle.loadString(filepath);
    final parts = script.split(RegExp(r"#{5,}[\t ]*[\r\n]+", multiLine: true));
    final partnum = downgradePart ? 1 : 0;
    final statements = parts[partnum].split(RegExp(r";[\t ]*[\r\n]+", multiLine: true));

    for (var statement in statements)
    {
      statement = statement.trim();

      if(statement.isNotEmpty)
        batch.execute(statement);
    }
  }
}