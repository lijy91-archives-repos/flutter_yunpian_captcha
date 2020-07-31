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

  test('getPlatformVersion', () async {
    expect(await FlutterYunpianCaptcha.platformVersion, '42');
  });
}
