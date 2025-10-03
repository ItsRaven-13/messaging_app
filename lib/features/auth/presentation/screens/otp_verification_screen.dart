import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:messaging_app/core/constants/app_routes.dart';
import 'package:messaging_app/core/widgets/connectivity_wrapper.dart';
import 'package:messaging_app/core/utils/network_utils.dart';
import 'package:messaging_app/features/auth/presentation/providers/auth_provider.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _codeController = TextEditingController();

  void _verifyCode(AuthProvider auth) async {
    final hasInternet = await NetworkUtils.hasInternetConnection();
    if (!hasInternet) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No hay conexión a Internet")),
      );
      return;
    }

    auth.verifyCode(
      smsCode: _codeController.text.trim(),
      onSuccess: (_) => context.goNamed(AppRoutes.home),
      onError: (error) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return ConnectivityWrapper(
      child: Scaffold(
        appBar: AppBar(title: const Text("Verificación")),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Se envió un código a ${widget.phoneNumber}"),
              const SizedBox(height: 20),
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Código de verificación",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              auth.loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () => _verifyCode(auth),
                      child: const Text("Verificar"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
