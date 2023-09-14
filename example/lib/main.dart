import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notifier_bloc/notifier_bloc_listener.dart';

import 'bloc/counter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: NotifierBlocListener<CounterBloc, CounterNotification>(
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Builder(
                builder: (context) {
                  final counterValue = context.watch<CounterBloc>().state.value;

                  return Text(
                    counterValue.toString(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () => context.read<CounterBloc>().add(Increment()),
            tooltip: 'Increment',
            child: const Icon(Icons.exposure_plus_1),
          ),
          const SizedBox(height: 15),
          FloatingActionButton(
            onPressed: () => context.read<CounterBloc>().add(Decrement()),
            tooltip: 'Decrement',
            child: const Icon(Icons.exposure_minus_1),
          ),
          const SizedBox(height: 15),
          FloatingActionButton(
            onPressed: () => context.read<CounterBloc>().add(Reset()),
            tooltip: 'Reset',
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
