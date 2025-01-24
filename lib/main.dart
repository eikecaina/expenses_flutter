import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_curso/binds/user.dart';
import 'package:flutter_curso/firebase_options.dart';
import 'package:flutter_curso/i10/auth.dart';
import 'package:flutter_curso/pages/auth.dart';
import 'package:flutter_curso/pages/home.dart';
import 'package:flutter_curso/pages/profile.dart';
import 'package:flutter_curso/pages/splash.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;

Future<void> main() async {
  await initializeDateFormatting('pt_BR', null);

  await GetStorage.init();

  WidgetsFlutterBinding.ensureInitialized();
  app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        FirebaseUILocalizations.withDefaultOverrides(const LabelOverrides()),
        FirebaseUILocalizations.delegate,
      ],
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(
          name: '/auth',
          page: () => const AuthPage(),
          binding: UserBind(),
        ),
        GetPage(
          name: '/splash',
          page: () => SplashScreen(),
        ),
        GetPage(name: '/home', page: () => Home(), binding: UserBind()),
        GetPage(
          name: '/profile',
          page: () => Profile(),
          binding: UserBind(),
        )
      ],
    );
  }
}
