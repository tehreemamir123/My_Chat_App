import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../data/repository/auth_repository.dart';
import '../home/home_screen.dart';
import '../presentation/screens/LoginScreen.dart';
import '../router/app_router.dart';

class SplashScreen extends StatefulWidget {
   SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer( Duration(seconds: 6), () {
      final authRepository = GetIt.I<AuthRepository>();
      final currentUser = authRepository.auth.currentUser;

      if (currentUser != null) {
        GetIt.I<AppRouter>().pushAndRemoveUntil(const HomeScreen());
      } else {
        GetIt.I<AppRouter>().pushAndRemoveUntil(const LoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff692960),
        title: Text("Welcome to my app",
          style: TextStyle(fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white),),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
          Expanded(
          child: Container(
            alignment: Alignment.center,
            child:Column(
          children: [
          Expanded(
          child: Container(
            child:Image.asset("assets/images/welcome.jpg"),
          ),
              ),
            Container(
              margin: EdgeInsets.only(bottom: 50),
              alignment: Alignment.center,
              child: Text("Developed By Tehreem Amir",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            )
          ]),
          ),
          ),
            ])),
      ),
    );
  }
}
