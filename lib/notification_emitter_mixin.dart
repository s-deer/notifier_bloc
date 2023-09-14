import 'dart:async';

import 'notification_provider.dart';

mixin NotificationEmitterMixin<T> implements NotificationProvider<T> {
  final _notificationStreamController = StreamController<T>.broadcast();

  void emitNotification(T notification) => _notificationStreamController.add(notification);

  @override
  Stream<T> get notificationStream => _notificationStreamController.stream;

  Future<void> closeNotificationStream() {
    return _notificationStreamController.close();
  }
}
