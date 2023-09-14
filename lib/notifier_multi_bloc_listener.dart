import 'package:provider/provider.dart';

import 'notifier_bloc_listener.dart';

class MultiNotifierBlocListener extends MultiProvider {
  MultiNotifierBlocListener({
    required List<NotifierBlocListener> listeners,
    super.child,
    super.key,
  }) : super(providers: listeners);
}
