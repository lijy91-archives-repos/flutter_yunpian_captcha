import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_yunpian_captcha/flutter_yunpian_captcha.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  YunPianCaptcha.init('a572b94d632b41d4be2fe873e5fcc37c');

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _sdkVersion = 'Unknown';
  List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String sdkVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      sdkVersion = await YunPianCaptcha.sdkVersion;
    } on PlatformException {
      sdkVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _sdkVersion = sdkVersion;
    });
  }

  void _handleClickVerify() async {
    YunPianCaptchaConfig config = YunPianCaptchaConfig(
      expired: 30,
      // lang: 'en',
      // langPack: {
      //   'YPcaptcha_02': '请按顺序点击:',
      //   'YPcaptcha_03': '向右拖动滑块填充拼图',
      //   'YPcaptcha_04': '验证失败，请重试',
      // },
      alpha: 0.3,
      showLoadingView: true,
      username: 'yunpian-captcha',
    );
    await YunPianCaptcha.verify(
      config: config,
      onLoaded: () {
        _addLog('onLoaded', null);
      },
      onSuccess: (dynamic data) {
        _addLog('onSuccess', data);
      },
      onFail: (dynamic data) {
        _addLog('onFail', data);
      },
    );
  }

  void _addLog(String method, dynamic data) {
    _logs.add('>>>$method');
    if (data != null) _logs.add(json.encode(data));
    _logs.add(' ');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Text('SDKVersion: $_sdkVersion'),
                    SizedBox(height: 10),
                    RaisedButton(
                      child: Text('验证'),
                      onPressed: () => _handleClickVerify(),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    for (var log in _logs)
                      Text(
                        log,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
