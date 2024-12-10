import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gsy_github_app_flutter/app.dart';
import 'package:gsy_github_app_flutter/env/config_wrapper.dart';
import 'package:gsy_github_app_flutter/env/env_config.dart';
import 'package:gsy_github_app_flutter/init/app_init.dart';
import 'package:gsy_github_app_flutter/page/error_page.dart';

import 'env/dev.dart';

void main() async {
  // 确保 Flutter 绑定初始化
  /// 注意：需要添加下面的一行，才可以使用 异步方法
  WidgetsFlutterBinding.ensureInitialized();

  //初始化app基础库
  await AppInit.run();

  runZonedGuarded(() {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      Zone.current.handleUncaughtError(details.exception, details.stack!);

      ///此处仅为展示，正规的实现方式参考 _defaultErrorWidgetBuilder 通过自定义 RenderErrorBox 实现
      return ErrorPage("${details.exception}\n ${details.stack}", details);
    };

    runApp(ConfigWrapper(
      config: EnvConfig.fromJson(config),
      child: const FlutterReduxApp(),
    ));

    ///屏幕刷新率和显示率不一致时的优化，必须挪动到 runApp 之后
    GestureBinding.instance.resamplingEnabled = true;
  }, (Object obj, StackTrace stack) {
    if (kDebugMode) {
      print(obj);
      print(stack);
    }
  });
}
