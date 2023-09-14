import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'notification_provider.dart';

typedef BlocNotificationHandler<T> = void Function(BuildContext, T);

class NotifierBlocListener<T extends NotificationProvider<N>, N> extends SingleChildStatefulWidget {
  final T? bloc;
  final BlocNotificationHandler<N> onNotification;

  const NotifierBlocListener({
    required this.onNotification,
    super.child,
    this.bloc,
    super.key,
  });

  @override
  State<NotifierBlocListener<T, N>> createState() => _NotifierBlocListenerState<T, N>();
}

class _NotifierBlocListenerState<T extends NotificationProvider<N>, N>
    extends SingleChildState<NotifierBlocListener<T, N>> {
  late T _bloc;
  StreamSubscription<N>? _subscription;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc ?? context.read<T>();

    _subscribe();
  }

  @override
  void didUpdateWidget(covariant NotifierBlocListener<T, N> oldWidget) {
    final oldBloc = oldWidget.bloc ?? context.read<T>();
    final currentBloc = widget.bloc ?? oldBloc;

    if (oldBloc != currentBloc) {
      _bloc = currentBloc;

      if (_subscription != null) {
        _unsubscribe();
      }

      _subscribe();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    final bloc = widget.bloc ?? context.read<T>();

    if (_bloc != bloc) {
      if (_subscription != null) {
        _unsubscribe();
      }

      _bloc = bloc;

      _subscribe();
    }

    super.didChangeDependencies();
  }

  void _subscribe() {
    _subscription = _bloc.notificationStream.listen((event) {
      widget.onNotification(context, event);
    });
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    assert(
      child != null,
      '''${widget.runtimeType} used outside of MultiBlocListener must specify a child''',
    );
    if (widget.bloc == null) {
      // Trigger a rebuild if the bloc reference has changed.
      // See https://github.com/felangel/bloc/issues/2127.
      context.select<T, bool>((bloc) => identical(_bloc, bloc));
    }

    return child!;
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }
}
