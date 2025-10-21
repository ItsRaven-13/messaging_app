import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:messaging_app/core/constants/app_routes.dart';
import 'package:messaging_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class HomeChatScreen extends StatelessWidget {
  const HomeChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        title: const Text('Mensajeria'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'logout':
                  await auth.signOut();
                  context.goNamed(AppRoutes.welcome);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: const Center(child: Text('Welcome to the Home Screen!')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(AppRoutes.contacts);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
