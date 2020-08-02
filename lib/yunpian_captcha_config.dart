class YunPianCaptchaConfig {
  // 请求验证码过期时限。单位秒，默认 30
  final int expired;
  // 支持语言，默认简体中文。zh-cn(简体中文)、en(英文)
  final String lang;
  // 验证码语言包。当设置 langPack 后 lang 设置会自动失效。
  // YPcaptcha_02 // 默认：请按顺序点击:
  // YPcaptcha_03 // 默认：向右拖动滑块填充拼图
  // YPcaptcha_04 // 默认：验证失败，请重试
  final Map<String, dynamic> langPack;
  // 视图透明度。默认 0.3
  final num alpha;
  // 是否显示加载指示器。默认显示
  final bool showLoadingView;
  // 添加无感验证参数
  final String username;

  YunPianCaptchaConfig({
    this.expired,
    this.lang,
    this.langPack,
    this.alpha,
    this.showLoadingView,
    this.username,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> jsonObject = Map<String, dynamic>();
    if (expired != null) jsonObject.putIfAbsent("expired", () => expired);
    if (lang != null) jsonObject.putIfAbsent("lang", () => lang);
    if (langPack != null) jsonObject.putIfAbsent("langPack", () => langPack);
    if (alpha != null) jsonObject.putIfAbsent("alpha", () => alpha);
    if (showLoadingView != null)
      jsonObject.putIfAbsent("showLoadingView", () => showLoadingView);
    if (username != null) jsonObject.putIfAbsent("username", () => username);

    return jsonObject;
  }
}
