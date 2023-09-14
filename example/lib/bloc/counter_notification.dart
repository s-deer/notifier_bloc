part of 'counter_bloc.dart';

sealed class CounterNotification {}

class IncrementedNotification extends CounterNotification {}

class DecrementedNotification extends CounterNotification {}

class ResetNotification extends CounterNotification {}
