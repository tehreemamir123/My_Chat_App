import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/theme/app_theme.dart';
import 'data/repository/chat_repository.dart';
import 'data/services/service_locator.dart';
import 'home/splash screen.dart';
import 'logic/cubits/auth/auth_cubit.dart';
import 'logic/cubits/auth_state.dart';
import 'logic/observer/app_life_cycle.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator(); // Make sure your GetIt setup is awaited
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppLifeCycleObserver? _lifeCycleObserver;

  @override
  void initState() {
    super.initState();

    // Listen to AuthCubit state changes and add lifecycle observer accordingly
    getIt<AuthCubit>().stream.listen((state) {
      if (state.status == AuthStatus.authenticated && state.user == null) {
        _lifeCycleObserver = AppLifeCycleObserver(
          userId: state.user!.uid,
          chatRepository: getIt<ChatRepository>(),
        );
        WidgetsBinding.instance.addObserver(_lifeCycleObserver!);
      } else {
        // Remove observer when unauthenticated or initial
        if (_lifeCycleObserver != null) {
          WidgetsBinding.instance.removeObserver(_lifeCycleObserver!);
          _lifeCycleObserver = null;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp(
        title: 'Messenger App',
        navigatorKey: getIt<AppRouter>().navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home:  SplashScreen(), // Show SplashScreen first
      ),
    );
  }
}
