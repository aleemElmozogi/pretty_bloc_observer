library pretty_bloc_observer;

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrettyBlocObserver extends BlocObserver {
  final int maxWidth;
  final void Function(Object object) logPrint;

  PrettyBlocObserver({this.logPrint = print, this.maxWidth = 80});

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      _printBoxed(header: 'onChange ══ ${bloc.runtimeType}', text: '$change');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    if (kDebugMode) {
      _printBoxed(header: 'onError ══ ${bloc.runtimeType}', text: '$error');
    }
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    if (kDebugMode) {
      _printBoxed(header: 'onClosed ══ ${bloc.runtimeType}');
    }
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    if (kDebugMode) {
      _printBoxed(header: 'onCreated ══ ${bloc.runtimeType}');
    }
  }

  void _printBoxed({String? header, String? text}) {
    logPrint('');
    logPrint('╔╣ $header');
    logPrint('║ ${DateTime.now().toIso8601String()}');

    if (text != null && text.isNotEmpty) {
      final List<String> lines = _splitLinesIfNeeded(text);
      for (var line in lines) {
        if (line.contains('currentState:')) {
          line = line.replaceFirst('Change { currentState:', 'currentState:');
          logPrint('║ ═> $line');
        } else if (line.contains('nextState:')) {
          logPrint('║      ══════════════════════════════');
          logPrint('║ ═>$line');
        } else {
          logPrint('║ $line');
        }
      }
    }
    logPrint('╚═${'═' * maxWidth}═╝');
  }

  List<String> _splitLinesIfNeeded(String text) {
    final List<String> lines = [];
    int start = 0;
    while (start < text.length) {
      int end = start + maxWidth;
      if (end >= text.length) {
        end = text.length;
      } else {
        int lastSpace = text.lastIndexOf(', ', end);
        if (lastSpace > start) {
          end = lastSpace + 1;
        }
      }
      lines.add(text.substring(start, end).trim());
      start = end;
    }
    return lines;
  }
}
