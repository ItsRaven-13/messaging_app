import 'package:flutter/material.dart';
import 'package:messaging_app/app/app.dart';
import 'package:messaging_app/app/app_initializer.dart';
import 'package:messaging_app/app/router/app_router.dart';
import 'package:messaging_app/features/auth/presentation/providers/auth_provider.dart'
    as auth_provider;
import 'package:messaging_app/features/chat/presentation/providers/chat_provider.dart';
import 'package:messaging_app/features/contacts/presentation/providers/contacts_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.initialize();
  final chatProvider = ChatProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => auth_provider.AuthProvider(chatProvider: chatProvider),
        ),
        ChangeNotifierProvider(create: (_) => ContactsProvider()),
        ChangeNotifierProvider.value(value: chatProvider),
      ],
      child: MyApp(router: appRouter),
    ),
  );
}
