import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:amigotools/config/views/LoginConfig.dart';
import 'package:amigotools/utils/types/Proc.dart';
import 'package:amigotools/config/services/SettingsConfig.dart';
import 'package:amigotools/view_models/general/AppStateModel.dart';
import 'package:amigotools/view_models/account/LoginModel.dart';
import 'package:amigotools/view_models/settings/SettingsModel.dart';
import 'package:amigotools/config/views/GeneralConfig.dart';

class PinPadScreen extends StatefulWidget {
  static const routeName = "/pinpad";

  @override
  _PinPadScreenState createState() => _PinPadScreenState();
}

class _PinPadScreenState extends State<PinPadScreen> {
  final buttonSize = 64.0;

  String _pin = "";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginModel(),
      builder: (context, child) =>
          Consumer3<AppStateModel, LoginModel, SettingsModel>(
        builder: (context, appstate, login, settings, widget) => Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 24),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            appstate.appName,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: GeneralConfig.palette2SupportingCyan400,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            settings.getString(SettingsKeys.ConsumerName),
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: GeneralConfig.palette2SupportingCyan400,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  login.loginError && _pin.isEmpty
                      ? "Error".tr()
                      : (login.communicating
                          ? "Authenticating".tr() + "..."
                          : "Enter PIN code".tr()),
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 22,
                    color: login.loginError && _pin.isEmpty
                        ? GeneralConfig.palette2SupportingRed700
                        : null,
                  ),
                ),
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: Iterable<int>.generate(
                          _pin.length <= LoginConfig.MinPinLen
                              ? LoginConfig.MinPinLen
                              : _pin.length)
                      .map<Widget>((x) => _createPoint(x <= _pin.length - 1))
                      .toList(),
                ),
                SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _createButton('1'),
                    _createButton('2'),
                    _createButton('3'),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _createButton('4'),
                    _createButton('5'),
                    _createButton('6'),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _createButton('7'),
                    _createButton('8'),
                    _createButton('9'),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _createButton(null,
                        icon: Icons.close,
                        iconcolor: GeneralConfig.palette2SupportingRed700,
                        onClick: _pin.isNotEmpty
                            ? () => setState(() => _pin = "")
                            : null),
                    _createButton('0'),
                    _createButton(null,
                        icon: Icons.check_outlined,
                        iconcolor: GeneralConfig.palette2SupportingCyan400,
                        onClick: _pin.length >= LoginConfig.MinPinLen
                            ? () {
                                login.loginWithPin(_pin);
                                setState(() => _pin = "");
                              }
                            : null),
                  ],
                ),
                SizedBox(height: 64)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createPoint(bool state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: state
              ? GeneralConfig.palette2SupportingCyan400
              : GeneralConfig.palette2Neutrals100,
          shape: BoxShape.circle,
          border: Border.all(
            width: 1,
            color: state
                ? GeneralConfig.palette2SupportingCyan400
                : GeneralConfig.palette2Neutrals100,
          ),
        ),
      ),
    );
  }

  Widget _createButton(String? buttonText,
      {IconData? icon, Color? iconcolor, Proc? onClick}) {
    final isActive = buttonText != null || onClick != null;

    return Container(
      height: buttonSize,
      width: buttonSize,
      decoration: BoxDecoration(
          //     border: Border.all(
          //     color: GeneralConfig.palette2Neutrals100,
          ),
      // borderRadius: BorderRadius.all(Radius.circular(buttonSize))),
      child: TextButton(
        onPressed: isActive
            ? () {
                if (onClick != null) {
                  onClick();
                } else if (buttonText != null &&
                    _pin.length < LoginConfig.MaxPinLen) {
                  setState(() => _pin += buttonText);
                }
              }
            : null,
        child: Center(
          child: buttonText != null
              ? Text(
                  buttonText,
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 36),
                )
              : Icon(
                  icon,
                  color:
                      isActive ? iconcolor : GeneralConfig.palette2Neutrals300,
                  size: 32,
                ),
        ),
        style: TextButton.styleFrom(
          primary: GeneralConfig.palette2Primary800,
          shape: CircleBorder(),
          side: BorderSide(
            width: 0,
            color: GeneralConfig.palette2Neutrals0,
          ),
        ),
      ),
    );
  }
}
