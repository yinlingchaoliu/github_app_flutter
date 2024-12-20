import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lib_mvvm/log/log_util.dart';

import 'view_state.dart';

/**
 * 通过状态改变来通知刷新
 */
class ViewStateModel with ChangeNotifier {
  /// 防止页面销毁后,异步任务才完成,导致报错
  bool _disposed = false;

  /// 当前的页面状态,默认为busy,可在viewModel的构造方法中指定;
  ViewState _viewState;

  CancelToken _cancelToken;

  /// ViewStateError
  ViewStateError? _viewStateError;

  /// 根据状态构造
  /// 子类可以在构造函数指定需要的页面状态
  /// FooModel():super(viewState:ViewState.busy);
  ViewStateModel({ViewState? viewState, CancelToken? cancelToken})
      : _viewState = viewState ?? ViewState.first,
        _cancelToken = cancelToken ?? CancelToken() {
    LogUtil.v('ViewStateModel---constructor--->$runtimeType');
  }

  /// ViewState
  ViewState get viewState => _viewState;

  CancelToken get cancelToken => _cancelToken;

  ViewStateError? get viewStateError => _viewStateError;

  set viewState(ViewState viewState) {
    if (viewState != ViewState.error) {
      _viewStateError = null;
    }

    _viewState = viewState;
    notifyListeners();
  }

  // 快速判断当前state状态
  bool get isFirst => viewState == ViewState.first;

  bool get isBusy => viewState == ViewState.busy;

  bool get isIdle => viewState == ViewState.idle;

  bool get isEmpty => viewState == ViewState.empty;

  bool get isError => viewState == ViewState.error;

  bool get isSuccess => viewState == ViewState.success;

  /// set
  void setIdle() {
    viewState = ViewState.idle;
  }

  void setBusy() {
    viewState = ViewState.busy;
  }

  void setEmpty() {
    viewState = ViewState.empty;
  }

  void setSuccess() {
    viewState = ViewState.success;
  }

  void setError(String errno, {String? message}) {
    _viewStateError = ViewStateError(
      errno,
      message: message,
    );

    viewState = ViewState.error;
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    if (!_cancelToken.isCancelled) {
      _cancelToken.cancel();
    }
    LogUtil.v('ViewStateModel dispose -->$runtimeType');
    super.dispose();
  }

  @override
  String toString() {
    return 'BaseModel{_viewState: $viewState, _viewStateError: $_viewStateError}';
  }
}
