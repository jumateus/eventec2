import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'view/cadastrar_view.dart';
import 'view/login_view.dart';
import 'view/principal_view.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => MaterialApp(
        useInheritedMediaQuery: true,
        debugShowCheckedModeBanner: false,
        initialRoute: 'login',
        routes: {
          'cadastrar': (context) => const CadastrarView(),
          'login': (context) => const LoginView(),
          'principal': (context) => const PrincipalView(),
        },
      ),
    ),
  );
}
