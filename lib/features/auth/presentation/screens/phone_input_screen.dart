import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:messaging_app/app/router/route_helpers.dart';
import 'package:provider/provider.dart';
import 'package:messaging_app/core/constants/app_routes.dart';
import 'package:messaging_app/core/widgets/connectivity_wrapper.dart';
import 'package:messaging_app/core/utils/network_utils.dart';
import 'package:messaging_app/features/auth/presentation/providers/auth_provider.dart';

class PhoneInputScreen extends StatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final TextEditingController _phoneController = TextEditingController();

  void _sendCode(AuthProvider auth) async {
    final phoneNumber = "+52${_phoneController.text.trim()}";
    final hasInternet = await NetworkUtils.hasInternetConnection();
    if (!hasInternet) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No hay conexión a Internet")),
      );
      return;
    }

    auth.sendCode(
      phoneNumber: phoneNumber,
      onCodeSent: () => context.goNamed(
        AppRoutes.otpVerification,
        extra: OtpVerificationArgs(phoneNumber),
      ),
      onVerified: (_) => context.goNamed(AppRoutes.home),
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
        appBar: AppBar(title: const Text("Verificación de teléfono")),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text(
                "Ingresa tu número de teléfono",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text("+52"),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: "Número de teléfono",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              auth.loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () => _sendCode(auth),
                      child: const Text("Enviar código"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
