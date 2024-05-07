import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pretty_bloc_observer/pretty_bloc_observer.dart';

void main() {
  // Set Pretty Bloc Observer as the Bloc observer
  Bloc.observer = PrettyBlocObserver();

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
