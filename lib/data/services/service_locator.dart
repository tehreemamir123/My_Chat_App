
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../firebase_options.dart';
import '../../logic/cubits/auth/auth_cubit.dart';
import '../../logic/cubits/chat cubit/chat.dart';
import '../../router/app_router.dart';
import '../repository/auth_repository.dart';
import '../repository/chat_repository.dart';
import '../repository/contact repository.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  getIt.registerLazySingleton(() => AppRouter());
  getIt.registerLazySingleton<FirebaseFirestore>(
          () => FirebaseFirestore.instance);
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => AuthRepository());
  getIt.registerLazySingleton(() => ContactRepository());
  getIt.registerLazySingleton(() => ChatRepository());
  getIt.registerLazySingleton(
        () => AuthCubit(
      authRepository: AuthRepository(),
    ),
  );
  getIt.registerFactory(
        () => ChatCubit(
      chatRepository: ChatRepository(),
      currentUserId: getIt<FirebaseAuth>().currentUser!.uid,
    ),
  );
}
