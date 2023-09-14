
Extended BLoC with ability to send notifications in separate stream

## Features
- Execute side effects like navigation/toasts/notifications etc..
- Show error messages

## Usage

### 1. Create Bloc 

```dart
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:notifier_bloc/notifier_bloc.dart';

part 'counter_event.dart';
part 'counter_state.dart';
part 'counter_notification.dart';

class CounterBloc extends NotifierBloc<CounterEvent, CounterState, CounterNotification> {
  CounterBloc() : super(const CounterState(0)) {
    on<Increment>(_onIncrement);
    on<Decrement>(_onDecrement);
    on<Reset>(_onReset);
  }

  FutureOr<void> _onIncrement(Increment event, Emitter<CounterState> emit) {
    emit(CounterState(state.value + 1));
  }

  FutureOr<void> _onDecrement(Decrement event, Emitter<CounterState> emit) {
    emit(CounterState(state.value - 1));
    emitNotification(DecrementedNotification());
  }

  FutureOr<void> _onReset(Reset event, Emitter<CounterState> emit) {
    emit(const CounterState(0));
    emitNotification(ResetNotification());
  }
}

```

### 2. Emit notification

```dart
emitNotification(IncrementedNotification());
```


### 3. Listen on notifications

```dart
NotifierBlocListener<CounterBloc, CounterNotification>(
    onNotification: (context, notification) {
      final message = switch (notification) {
        IncrementedNotification() => 'Counter Incremented',
        DecrementedNotification() => 'Counter Decremented',
        ResetNotification() => 'Counter reset completed'
      };

      final messenger = ScaffoldMessenger.of(context);

      messenger.hideCurrentSnackBar();

      messenger.showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    },
)
```