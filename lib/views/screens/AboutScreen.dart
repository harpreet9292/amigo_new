import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:amigotools/view_models/general/AppStateModel.dart';
import 'package:amigotools/config/views/GeneralConfig.dart';
import 'package:amigotools/config/services/SettingsConfig.dart';
import 'package:amigotools/config/views/AboutScreenConfig.dart';
import 'package:amigotools/view_models/settings/SettingsModel.dart';

class AboutScreen extends StatelessWidget {
  static const routeName = "/about";

  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppStateModel>();
    final settings = context.read<SettingsModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text("About us".tr()),
        actions: [
          //IconButton(onPressed: () {}, icon: Icon(Icons.tv_sharp)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Image(
                        width: 50,
                        image: AssetImage(path.join(
                            GeneralConfig.AssetImagesPath,
                            GeneralConfig.AppLogo))),
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Text(
                        "${appState.appName} v${appState.appVersion}",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        settings.getString(SettingsKeys.ConsumerName),
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Expanded(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: Scrollbar(
                  interactive: true,
                  child: ListView(shrinkWrap: true, children: <Widget>[
                    Text(
                      AboutScreenConfig.AboutUsText.tr(),
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 32),
                    InkWell(
                      child: Text(
                        "Phone".tr() + ": ${AboutScreenConfig.ContactPhone}",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      onTap: () =>
                          launch("tel:${AboutScreenConfig.ContactPhone}"),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: InkWell(
                          child: Text(AboutScreenConfig.WebSite,
                              style: TextStyle(
                                color: GeneralConfig.palette2Primary400,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              )),
                          onTap: () => launch(
                              "http://${AboutScreenConfig.WebSiteLink.tr()}")),
                    ),
                    SizedBox(height: 16),
                    Center(
                        child: ConstrainedBox(
                      constraints: BoxConstraints.tightFor(width: 250),
                      child: Text("${AboutScreenConfig.Slogan}".tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          )),
                    )),
                  ]),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text("Copyright © ${AboutScreenConfig.Copyright}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                )),
          ],
        ),
      ),
    );
  }
}
