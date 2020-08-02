import 'package:flutter/services.dart';

import './yunpian_captcha_config.dart';

const _kMethodChannelName = 'flutter_yunpian_captcha';
const _kEventChannelName = 'flutter_yunpian_captcha/event_channel';

class YunPianCaptcha {
  static const MethodChannel _methodChannel =
      const MethodChannel(_kMethodChannelName);
  static const EventChannel _eventChannel =
      const EventChannel(_kEventChannelName);

  static bool _eventChannelReadied = false;

  static Function() _verifyOnLoaded;
  static Function(dynamic) _verifyOnSuccess;
  static Function(dynamic) _verifyOnFail;
  static Function(dynamic) _verifyOnError;
  static Function() _verifyOnCancel;

  static Future<String> get sdkVersion async {
    final String sdkVersion = await _methodChannel.invokeMethod('getSDKVersion');
    return sdkVersion;
  }

  static Future<bool> init(String captchaId) async {
    if (_eventChannelReadied != true) {
      _eventChannel.receiveBroadcastStream().listen(_handleVerifyOnEvent);
      _eventChannelReadied = true;
    }

    return await _methodChannel.invokeMethod('init', {
      'captchaId': captchaId,
    });
  }

  static Future<bool> verify({
    YunPianCaptchaConfig config,
    Function() onLoaded,
    Function(dynamic data) onSuccess,
    Function(dynamic data) onFail,
  }) async {
    _verifyOnLoaded = onLoaded;
    _verifyOnSuccess = onSuccess;
    _verifyOnFail = onFail;

    return await _methodChannel.invokeMethod('verify', config?.toJson());
  }

  static _handleVerifyOnEvent(dynamic event) {
    String method = '${event['method']}';

    switch (method) {
      case 'onLoaded':
        if (_verifyOnLoaded != null) _verifyOnLoaded();
        break;
      case 'onSuccess':
        if (_verifyOnSuccess != null) _verifyOnSuccess(event['data']);
        break;
      case 'onFail':
        if (_verifyOnFail != null) _verifyOnFail(event['data']);
        break;
      case 'onError':
        if (_verifyOnError != null) _verifyOnError(event['data']);
        break;
      case 'onCancel':
        if (_verifyOnCancel != null) _verifyOnCancel();
        break;
    }
  }
}
