import 'package:lib_cache/lib_cache.dart';

/**
 * app 初始化
 */
class AppInit {
  //私有构造方法
  AppInit._();

  static Future<void> run() async {
    await CacheManager.getInstance().preInit();
    await SPUtil.preInit();
  }
}
