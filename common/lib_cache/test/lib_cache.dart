import 'package:lib_cache/lib_cache.dart';

/// A Calculator.
class Calculator {
  void test() async {
    await CacheManager.getInstance().preInit();
    await SPUtil.preInit();
    CacheManager.getInstance().set("dsddffdf", "xxx");
    SPUtil.putString("xxx", "xxx");
  }
}
