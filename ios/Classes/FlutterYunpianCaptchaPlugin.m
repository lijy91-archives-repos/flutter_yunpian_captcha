#import "FlutterYunpianCaptchaPlugin.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@implementation FlutterYunpianCaptchaPlugin {
    FlutterEventSink _eventSink;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"flutter_yunpian_captcha"
                                     binaryMessenger:[registrar messenger]];
    FlutterYunpianCaptchaPlugin* instance = [[FlutterYunpianCaptchaPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    
    FlutterEventChannel* eventChannel =
    [FlutterEventChannel eventChannelWithName:@"flutter_yunpian_captcha/event_channel"
                              binaryMessenger:[registrar messenger]];
    [eventChannel setStreamHandler:instance];
}

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
    _eventSink = eventSink;
    
    return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
    _eventSink = nil;
    
    return nil;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getSDKVersion" isEqualToString:call.method]) {
        [self handleMethodGetSDKVersion:call result:result];
    } else if ([@"init" isEqualToString:call.method]) {
        [self handleMethodInit:call result:result];
    } else if ([@"verify" isEqualToString:call.method]) {
        [self handleMethodVerify:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}


- (void)handleMethodGetSDKVersion:(FlutterMethodCall*)call
                           result:(FlutterResult)result
{
    NSString *sdkVersion = [YPCaptchaSDK getSDKVersion];
    
    result(sdkVersion);
}

- (void)handleMethodInit:(FlutterMethodCall*)call
                  result:(FlutterResult)result
{
    NSString *captchaId = call.arguments[@"captchaId"];
    [YPCaptchaSDK startWithCaptchaId:captchaId];
    
    result([NSNumber numberWithBool:YES]);
}

- (void)handleMethodVerify:(FlutterMethodCall*)call
                    result:(FlutterResult)result
{
    
    NSNumber *expired = call.arguments[@"expired"];
    NSString *lang = call.arguments[@"lang"];
    NSDictionary *langPack = call.arguments[@"langPack"];
    NSNumber *alpha = call.arguments[@"alpha"];
    NSNumber *showLoadingView = call.arguments[@"showLoadingView"];
    NSString *username = call.arguments[@"username"];
    
    YPConfigModel *configModel = [[YPConfigModel alloc] init];
    if (expired)
        configModel.expired = expired.intValue;
    if (lang)
        configModel.lang = lang;
    if (alpha)
        configModel.alpha = alpha.floatValue;
    if (showLoadingView)
        configModel.showLoadingView = showLoadingView.boolValue;
    if (username)
        configModel.username = username;
    
    YPLangPackModel *langPackModel = nil;
    if (langPack) {
        langPackModel =  [YPLangPackModel new];
        NSString *yPcaptcha_02 = langPack[@"YPcaptcha_02"];
        NSString *yPcaptcha_03 = langPack[@"YPcaptcha_03"];
        NSString *yPcaptcha_04 = langPack[@"YPcaptcha_04"];
        
        if (yPcaptcha_02)
            langPackModel.YPcaptcha_02 = yPcaptcha_02;
        if (yPcaptcha_03)
            langPackModel.YPcaptcha_03 = yPcaptcha_03;
        if (yPcaptcha_04)
            langPackModel.YPcaptcha_04 = yPcaptcha_04;
        
        configModel.langPack = langPackModel;
    }
    
    [YPCaptchaSDK verfiy:configModel
                onLoaded:^{
        NSDictionary<NSString *, id> *eventData = @{
            @"method": @"onLoaded",
        };
        self->_eventSink(eventData);
    }
               onSuccess:^(NSDictionary *_Nonnull info) {
        NSDictionary<NSString *, id> *eventData = @{
            @"method": @"onSuccess",
            @"data": info,
        };
        self->_eventSink(eventData);
    }
                  onFail:^(NSDictionary *_Nonnull info) {
        NSDictionary<NSString *, id> *eventData = @{
            @"method": @"onFail",
            @"data": info,
        };
        self->_eventSink(eventData);
    }];
    
    result([NSNumber numberWithBool:YES]);
}

@end
