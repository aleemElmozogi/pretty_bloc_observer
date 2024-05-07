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
    for (int i = 0; i < text.length; i++) {
      if (i - start >= maxWidth || i == text.length - 1) {
        if (i == text.length - 1) {
          lines.add(text.substring(start, i + 1));
        } else {
          final int endIndex = text.lastIndexOf(', ', i);
          if (endIndex == -1) {
            lines.add(text.substring(start, i + 1));
            start = i + 1;
          } else {
            lines.add(text.substring(start, endIndex));
            start = endIndex + 1;
          }
        }
      }
    }
    return lines;
  }
}

