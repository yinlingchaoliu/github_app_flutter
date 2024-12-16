import 'package:flutter/material.dart';
import "package:lib_mvvm/log/log_util.dart";
import "package:lib_mvvm/loading/loading_dialog.dart";

/**
 * 标准基础UI
 */
abstract class IBasePage {
  BuildContext getContext();

  void showLoading({String? content, bool showContent = true});

  void hideLoading();
}

/**
 * 基础实现
 */
mixin BasePageMixin<T extends StatefulWidget> on State<T> implements IBasePage {
  bool _isShowDialog = false;

  @override
  BuildContext getContext() {
    return context;
  }

  @override
  void showLoading({String? content, bool showContent = true}) {
    /// 避免重复弹出
    if (mounted && !_isShowDialog) {
      _isShowDialog = true;
      try {
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          barrierColor:
              const Color(0x00FFFFFF), // 默认dialog背景色为半透明黑色，这里修改为透明（1.20添加属性）
          builder: (_) {
            return WillPopScope(
              onWillPop: () async {
                // 拦截到返回键，证明dialog被手动关闭
                _isShowDialog = false;
                return Future.value(true);
              },
              child: buildLoading(content: content, showContent: showContent),
            );
          },
        );
      } catch (e) {
        /// 异常原因主要是页面没有build完成就调用Progress。
        print(e);
      }
    }
  }

  @override
  void hideLoading() {
    if (mounted && _isShowDialog) {
      _isShowDialog = false;
      FocusManager.instance.primaryFocus?.unfocus();
      Navigator.pop(context);
    }
  }

  // 可自定义Progress
  Widget buildLoading({String? content, bool showContent = true}) {
    return LoadingDialog(content: content, showContent: showContent);
  }

  @override
  void didChangeDependencies() {
    LogUtil.v('$T ==> didChangeDependencies');
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    LogUtil.v('$T ==> dispose');
    super.dispose();
  }

  @override
  void deactivate() {
    LogUtil.v('$T ==> deactivate');
    super.deactivate();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    //LogUtil.v('$T ==> didUpdateWidgets');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    LogUtil.v('$T ==> initState');
    super.initState();
  }
}
