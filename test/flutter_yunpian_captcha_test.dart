import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_yunpian_captcha/flutter_yunpian_captcha.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_yunpian_captcha');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getSDKVersion', () async {
    expect(await YunPianCaptcha.sdkVersion, '42');
  });
}
