import 'package:lib_cache/lib_cache.dart';

/**
 * app 初始化
 */
class AppInit {
  static Future<void> run() async {
    await CacheManager.getInstance().preInit();
    await SPUtil.preInit();
  }
}
