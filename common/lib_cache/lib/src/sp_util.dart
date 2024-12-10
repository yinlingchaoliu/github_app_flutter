import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

/// SPUtils 工具便于快速开发
/// @author chentong
/// @date 2019-04-02
///
class SPUtil {
  static SPUtil? _singleton;
  static Lock _lock = Lock();
  static SharedPreferences? _prefs;

  //私有构造方法
  SPUtil._internal();

  Future _initSp() async {
    _prefs = await SharedPreferences.getInstance();
  }

  ///线程安全 sp单例
  //todo 需要初始化 SpUtil.preInit()
  static Future<SPUtil> preInit() async {
    if (_singleton == null) {
      await _lock.synchronized(() async {
        if (_singleton == null) {
          var singleton = SPUtil._internal();
          await singleton._initSp();
          _singleton = singleton;
        }
      });
    }

    return _singleton!;
  }

  ///Sp is initialized.
  static bool isInitialized() {
    return _prefs != null;
  }

  static Future<bool> put(String key, Object? value) {
    if (_prefs == null) return Future.value(false);
    if (value == null) {
      return putString(key, "");
    }
    if (value is String) {
      return putString(key, value);
    } else if (value is int) {
      return putInt(key, value);
    } else if (value is bool) {
      return putBool(key, value);
    } else if (value is double) {
      return putDouble(key, value);
    } else if (value is List<String>) {
      return putStringList(key, value);
    } else {
      return putObject(key, value);
    }
  }

  /// get dynamic.
  static Object? get(String key, Object? defValue) {
    if (_prefs == null) return defValue;
    return _prefs!.get(key) ?? defValue;
  }

  /// put object.
  static Future<bool> putObject(String key, Object value) {
    if (_prefs == null) return Future.value(false);
    return _prefs!.setString(key, value == null ? "" : json.encode(value));
  }

  /// get object.
  static dynamic getObject(String key) {
    if (_prefs == null) return null;
    String _data = _prefs!.getString(key) ?? "";
    return (_data == null || _data.isEmpty) ? null : json.decode(_data);
  }

  /// get string.
  static getString(String key, {String defValue = ''}) {
    if (_prefs == null) return defValue;
    return _prefs!.getString(key) ?? defValue;
  }

  /// put string.
  static Future<bool> putString(String key, String value) {
    if (_prefs == null) return Future.value(false);
    return _prefs!.setString(key, value);
  }

  /// get bool.
  static bool getBool(String key, {bool defValue = false}) {
    if (_prefs == null) return defValue;
    return _prefs!.getBool(key) ?? defValue;
  }

  /// put bool.
  static Future<bool> putBool(String key, bool value) {
    if (_prefs == null) return Future.value(false);
    return _prefs!.setBool(key, value);
  }

  /// get int.
  static getInt(String key, {int defValue = 0}) {
    if (_prefs == null) return defValue;
    return _prefs!.getInt(key) ?? defValue;
  }

  /// put int.
  static Future<bool> putInt(String key, int value) {
    if (_prefs == null) return Future.value(false);
    return _prefs!.setInt(key, value);
  }

  /// get double.
  static double getDouble(String key, {double defValue = 0.0}) {
    if (_prefs == null) return defValue;
    return _prefs!.getDouble(key) ?? defValue;
  }

  /// put double.
  static Future<bool> putDouble(String key, double value) {
    if (_prefs == null) return Future.value(false);
    return _prefs!.setDouble(key, value);
  }

  /// get string list.
  static List<String> getStringList(String key,
      {List<String> defValue = const []}) {
    if (_prefs == null) return defValue;
    return _prefs!.getStringList(key) ?? defValue;
  }

  /// put string list.
  static Future<bool> putStringList(String key, List<String> value) {
    if (_prefs == null) return Future.value(false);
    return _prefs!.setStringList(key, value);
  }

  /// have key.
  static bool haveKey(String key) {
    if (_prefs == null) return false;
    return _prefs!.getKeys().contains(key);
  }

  /// get keys.
  static Set<String> getKeys() {
    if (_prefs == null) return Set();
    return _prefs!.getKeys();
  }

  /// remove.
  static Future<bool> remove(String key) {
    if (_prefs == null) return Future.value(false);
    return _prefs!.remove(key);
  }

  /// clear.
  static Future<bool> clear() {
    if (_prefs == null) return Future.value(false);
    return _prefs!.clear();
  }
}
