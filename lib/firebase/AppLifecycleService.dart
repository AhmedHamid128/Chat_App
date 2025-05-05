
import 'package:chat_app_with_firebase/firebase/firebase_auth_.dart';
import 'package:flutter/material.dart';

class AppLifecycleService with WidgetsBindingObserver {
  static final AppLifecycleService _instance = AppLifecycleService._internal();

  factory AppLifecycleService() => _instance;

  AppLifecycleService._internal() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FireAuth.updateLastSeen(true);
    } else if (state == AppLifecycleState.paused) {
      FireAuth.updateLastSeen(false);
    }
  }
}
