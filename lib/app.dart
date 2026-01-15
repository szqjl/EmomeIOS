import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/home_screen.dart';
import 'core/session_manager.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();
    // 初始化会话管理器
    final sessionManager = SessionManager();
    sessionManager.setupAutoCleanup();
  }

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
