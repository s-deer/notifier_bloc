import 'notification_emitter_mixin.dart';
import 'package:bloc/bloc.dart';

abstract class NotifierBloc<E, S, N> extends Bloc<E, S> with NotificationEmitterMixin<N> {
  NotifierBloc(S initialState) : super(initialState);

  @override
  Future<void> close() async {
    await closeNotificationStream();

    return super.close();
  }
}
