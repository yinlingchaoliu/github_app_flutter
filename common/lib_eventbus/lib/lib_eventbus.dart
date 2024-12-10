library lib_eventbus;

import 'package:lib_eventbus/event/event_bus.dart';

/**
 * 事件消息
 */
class Event {
  Event._();
  static final EventBus eventBus = EventBus();
}
