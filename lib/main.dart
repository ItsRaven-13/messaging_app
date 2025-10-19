import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/app/app.dart';
import 'package:messaging_app/core/providers/connectivity_provider.dart';
import 'package:messaging_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:messaging_app/firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    providerAndroid: kDebugMode
        ? AndroidDebugProvider()
        : AndroidPlayIntegrityProvider(),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
