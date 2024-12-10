import 'package:lib_cache/lib_cache.dart';

///SharedPreferences 本地存储
class LocalStorage {
  static save(String key, value) async {
    SPUtil.putString(key, value);
  }

  static get(String key) async {
    return SPUtil.get(key, null);
  }

  static remove(String key) async {
    SPUtil.remove(key);
  }
}
