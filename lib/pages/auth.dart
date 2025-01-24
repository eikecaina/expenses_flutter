import 'package:flutter/material.dart';

import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter_curso/controllers/user.dart';
import 'package:get/get.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final user = await Get.find<UserController>().getUser;

      if (user != '') {
        Get.offNamed('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final providers = [EmailAuthProvider()];

    return SignInScreen(
      providers: providers,
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) async {
          Get.find<UserController>().setUserToken =
              await state.user?.getIdToken();

          Get.offNamed('/home', arguments: {'type': 'signedIn'});
        }),
        AuthStateChangeAction<UserCreated>((context, state) {
          Get.offNamed('/home', arguments: {'type': 'userCreated'});
        }),
      ],
      headerBuilder: (context, constraints, shrinkOffset) {
        return Image.asset(
          'assets/icons/logo.png',
          height: constraints.maxHeight,
          width: constraints.maxWidth,
        );
      },
      sideBuilder: (context, constraints) {
        return Image.asset(
          'assets/icons/logo.png',
          height: constraints.maxHeight,
          width: constraints.maxWidth,
        );
      },
    );
  }
}
