part of 'counter_bloc.dart';

abstract class CounterEvent {
  const CounterEvent();
}

class Increment extends CounterEvent {}

class Decrement extends CounterEvent {}

class Reset extends CounterEvent {}
