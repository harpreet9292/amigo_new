import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amigotools/config/views/GeneralConfig.dart';
import 'package:amigotools/view_models/account/SystemLoginModel.dart';

class SystemLoginScreen extends StatefulWidget {
  const SystemLoginScreen();

  @override
  _SystemLoginScreenState createState() => _SystemLoginScreenState();
}

class _SystemLoginScreenState extends State<SystemLoginScreen> {
  final _model = SystemLoginModel();
  final _controllerIdent = TextEditingController();
  final _controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _model,
      builder: (context, child) => Consumer<SystemLoginModel>(
        builder: (context, _, widget) => Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            padding: new EdgeInsets.all(24.0),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 24),
                      Text(
                        "AmigoTools",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: GeneralConfig.palette2SupportingCyan400,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        _model.loginError
                            ? "Error"
                            : (_model.communicating ? "Authenticating..." : ""),
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 22,
                          color: _model.loginError
                              ? GeneralConfig.palette2SupportingRed700
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 8),
                      TextField(
                        controller: _controllerIdent,
                        textInputAction: TextInputAction.next,
                        autofocus: true,
                        style: TextStyle(
                          fontSize: 18.0,
                          height: 1.2,
                        ),
                        decoration: _createDecoration("System id"),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _controllerPassword,
                        textInputAction: TextInputAction.send,
                        obscureText: true,
                        onSubmitted: (val) => _onSubmit(),
                        style: TextStyle(
                          fontSize: 18.0,
                          height: 1.2,
                        ),
                        decoration: _createDecoration("Password"),
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity, // <-- match_parent
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(16),
                            primary: GeneralConfig
                                .palette2SupportingCyan400, // background
                            onPrimary: Colors.white, // foreground
                          ),
                          onPressed: _onSubmit,
                          child: Text('LOGIN'),
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _createDecoration(String label) {
    return InputDecoration(
      labelText: label,
      isDense: true,
      contentPadding: EdgeInsets.all(12),
      hintStyle: TextStyle(
        color: GeneralConfig.palette2Neutrals300,
      ),

      enabledBorder:
          _createBorder(width: 1.0, color: GeneralConfig.palette2Neutrals200),
      focusedBorder: _createBorder(
          width: 2.0, color: GeneralConfig.palette2SupportingCyan400),
      errorBorder: _createBorder(
          width: 1.0, color: GeneralConfig.palette2SupportingRed700),
      focusedErrorBorder: _createBorder(
          width: 2.0, color: GeneralConfig.palette2SupportingRed700),
      // errorText: "dfs",
      // errorStyle: TextStyle(
      //   color: GeneralConfig.palette2SupportingRed700,
      //   fontWeight: FontWeight.bold,
      // ),
    );
  }

  OutlineInputBorder _createBorder(
      {required double width, required Color color}) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: width,
      ),
      borderRadius: BorderRadius.circular(4.0),
    );
  }

  void _onSubmit() {
    final ident = _controllerIdent.value.text;
    final pass = _controllerPassword.value.text;

    if (ident.isNotEmpty && pass.isNotEmpty) {
      _model.login(
        ident: ident,
        pass: pass,
      );
    }
  }
}
