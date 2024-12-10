import 'package:shared_preferences/shared_preferences.dart';

/**
 * CacheManager 更倾向于业务使用
 * @author chentong
 * @date 2024-12-10
 */

class CacheManager {
  static SharedPreferences? _preferences;
  static CacheManager? _instance;

  //私有构造方案
  CacheManager._internal();

  //预初始化
  Future<void> preInit() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static CacheManager getInstance() {
    if (_instance == null) {
      _instance = CacheManager._internal();
    }
    return _instance!;
  }

  set(String key, Object value) {
    if (value is int) {
      _preferences?.setInt(key, value);
    } else if (value is String) {
      _preferences?.setString(key, value);
    } else if (value is double) {
      _preferences?.setDouble(key, value);
    } else if (value is bool) {
      _preferences?.setBool(key, value);
    } else if (value is List<String>) {
      _preferences?.setStringList(key, value);
    } else {
      throw Exception("only Support int、String、double、bool、List<String>");
    }
  }

  /**
   * 数据强行转换
   */
  T get<T>(String key) {
    return _preferences?.get(key) as T;
  }
}
