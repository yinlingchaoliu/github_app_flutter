import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:lib_router/router/i_router.dart';
import 'package:lib_router/router/page_builder.dart';
import 'package:lib_router/router/parameters.dart';

import 'package:lib_router/page/not_found_page.dart';

///使用fluro进行路由管理
class Routers {
  static FluroRouter? router;

  static Map<String, PageBuilder> pageRounters = {};

  static String webviewPage = '/webviewPage';
  static String inappWebviewPage = '/inappWebviewPage';

  static String mainPage = '/mainPage';

  static void init(List<IRouter> listRouter) {
    router = FluroRouter();
    configureRoutes(router!, listRouter);
  }

  ///路由配置
  static void configureRoutes(FluroRouter router, List<IRouter> listRouter) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return NotFoundPage();
    });

    // PageBuilder webviewPageBuilder = PageBuilder(Routers.webviewPage, (params) {
    //   String? title = params?.getString('title');
    //   String? url = params?.getString('url');
    //   return WebViewPage(url, title);
    // });
    //
    // router.define(Routers.webviewPage, handler: webviewPageBuilder.handler);
    // pageRounters[Routers.webviewPage] = webviewPageBuilder;

    listRouter.forEach((routerImpl) {
      List<PageBuilder> pages = routerImpl.getPageBuilders();
      pages.forEach((page) {
        router.define(page.path, handler: page.handler);
        pageRounters[page.path] = page;
      });
    });
  }

  /**
   * 生成对应的page
   */
  static Widget? generatePage(BuildContext context, String path,
      {Parameters? parameters}) {
    PageBuilder? pageBuilder = pageRounters[path];
    if (pageBuilder != null) {
      pageBuilder.parameters = parameters ?? Parameters();
      return pageBuilder.handler!.handlerFunc(context, {});
    } else {
      return router!.notFoundHandler!.handlerFunc(context, {});
    }
  }

  // 对参数进行encode，解决参数中有特殊字符，影响fluro路由匹配(https://www.jianshu.com/p/e575787d173c)
  static Future navigateTo(BuildContext context, String path,
      {Parameters? parameters,
      bool clearStack = false,
      TransitionType transition = TransitionType.cupertino}) {
    var pageBuilder = pageRounters[path];
    if (pageBuilder != null) {
      pageBuilder.parameters = parameters ?? Parameters();
    }

//    String query = "";
//    if (params != null) {
//      int index = 0;
//      for (var key in params.keys) {
//        var value = Uri.encodeComponent(params[key]);
//        if (index == 0) {
//          query = "?";
//        } else {
//          query = query + "\&";
//        }
//        query += "$key=$value";
//        index++;
//      }
//    }
//
//    path = path + query;
    return router!.navigateTo(context, path,
        clearStack: clearStack, transition: transition);
  }

  static void navigateToResult(BuildContext context, String path,
      Parameters parameters, Function(Object) function,
      {bool clearStack = false,
      TransitionType transition = TransitionType.cupertino}) {
    unfocus();
    navigateTo(context, path,
            parameters: parameters,
            clearStack: clearStack,
            transition: transition)
        .then((Object? result) {
      // 页面返回result为null
      if (result == null) {
        return;
      }
      function(result);
    }).catchError((dynamic error) {});
  }

  /// 返回
  static void goBack(BuildContext context) {
    unfocus();
    Navigator.pop(context);
  }

  /// 带参数返回
  static void goBackWithParams(BuildContext context, Object result) {
    unfocus();
    Navigator.pop<Object>(context, result);
  }

  static void unfocus() {
    // 使用下面的方式，会触发不必要的build。
    // FocusScope.of(context).unfocus();
    // https://github.com/flutter/flutter/issues/47128#issuecomment-627551073
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // //默认跳转到登录页面
  // static void loginGuardNavigateTo(BuildContext context, String path,
  //     {Parameters? parameters,
  //     bool clearStack = false,
  //     TransitionType transition = TransitionType.cupertino}) {
  //   if (RTAccount.instance()!.isLogin()) {
  //     Routers.navigateTo(context, path,
  //         parameters: parameters,
  //         clearStack: clearStack,
  //         transition: transition);
  //   } else {
  //     Routers.navigateTo(context, Routers.loginPage);
  //   }
  // }
}
