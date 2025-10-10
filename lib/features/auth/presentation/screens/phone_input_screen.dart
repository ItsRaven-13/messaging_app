import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:messaging_app/app/router/route_helpers.dart';
import 'package:messaging_app/features/auth/domain/validators/phone_validator.dart';
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
  final _formKey = GlobalKey<FormState>();
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
      onVerified: (user, smsCode) {
        if (smsCode != null) {
          context.goNamed(
            AppRoutes.otpVerification,
            extra: OtpVerificationArgs(
              phoneNumber,
              autodetectedSmsCode: smsCode,
            ),
          );
        } else {
          context.goNamed(AppRoutes.home);
        }
      },
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
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const Text(
                  "Ingresa tu número de teléfono",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: '+52',
                  items: [
                    const DropdownMenuItem<String>(
                      value: '+52',
                      child: Center(child: Text('México')),
                    ),
                  ],
                  onChanged: null,
                  isExpanded: true,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        enabled: false,
                        decoration: const InputDecoration(hintText: "+52"),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        validator: PhoneValidator.validate,
                        decoration: const InputDecoration(
                          hintText: "Número de teléfono",
                          counterText: "",
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
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _sendCode(auth);
                          }
                        },
                        child: const Text("Enviar código"),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
