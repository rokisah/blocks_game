import 'package:flutter/widgets.dart';

class AppStateObserver extends WidgetsBindingObserver {

  void didChangeAppLifecycleState(AppLifecycleState state) { 
    if (state == AppLifecycleState.resumed) {
      
    } else {
      
    }
  }

}