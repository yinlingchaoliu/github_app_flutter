import 'package:lib_router/router/page_builder.dart';

abstract class IRouter {
  List<PageBuilder> getPageBuilders();
}
