import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WidgetLifecycleHandler extends WidgetsBindingObserver {
  final AsyncCallback onResumed;
  final AsyncCallback onInActive;
  final AsyncCallback onPaused;

  WidgetLifecycleHandler({
    required this.onResumed,
    required this.onInActive,
    required this.onPaused,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        {
          await onResumed();
          break;
        }
      case AppLifecycleState.inactive:
        {
          await onInActive();
          break;
        }
      case AppLifecycleState.paused:
        {
          await onPaused();

          break;
        }
      case AppLifecycleState.detached:
        {
          break;
        }
    }
  }
}
