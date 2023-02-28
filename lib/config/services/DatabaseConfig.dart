abstract class DatabaseConfig
{
  static const DefaultFileName = "default.db";

  static const MigrationFilesPath = "assets/sql/";

  static const MigrationFiles = const [
    "01_initial_schema.sql",
  ];

  static const SchemaVersion = 1;
}