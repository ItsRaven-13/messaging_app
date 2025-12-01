import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:messaging_app/core/constants/app_routes.dart';
import 'package:messaging_app/core/styles/pin_theme_styles.dart';
import 'package:messaging_app/features/auth/domain/validators/otp_validator.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:messaging_app/core/utils/network_utils.dart';
import 'package:messaging_app/features/auth/presentation/providers/auth_provider.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String? autodetectedSmsCode;
  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    this.autodetectedSmsCode,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.autodetectedSmsCode != null &&
        widget.autodetectedSmsCode!.length == 6) {
      _codeController.text = widget.autodetectedSmsCode!;
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _verifyCode(AuthProvider auth) async {
    final smsCode = _codeController.text.trim();

    final hasInternet = await NetworkUtils.hasInternetConnection();
    if (!hasInternet) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No hay conexión a Internet")),
      );
      return;
    }

    auth.verifyCode(
      smsCode: smsCode,
      onSuccess: (_) {
        if (context.mounted) {
          context.goNamed(AppRoutes.home);
        }
      },
      onError: (error) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error))),
    );
  }

  void _onCompleted(String pin, AuthProvider auth) {
    _codeController.text = pin;
    if (_formKey.currentState!.validate()) {
      _verifyCode(auth);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final defaultPinTheme = PinThemeStyles.getDefaultTheme(context);
    final focusedPinTheme = PinThemeStyles.getFocusedTheme(context);
    final errorPinTheme = PinThemeStyles.getErrorTheme(context);
    final submittedPinTheme = PinThemeStyles.getSubmittedTheme(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Verificación")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Se envió un código a ${widget.phoneNumber}"),
              const SizedBox(height: 20),
              Pinput(
                controller: _codeController,
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                errorPinTheme: errorPinTheme,
                validator: OtpValidator.isValid,
                keyboardType: TextInputType.number,
                onCompleted: (pin) => _onCompleted(pin, auth),
              ),
              const SizedBox(height: 24),
              auth.loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _verifyCode(auth);
                        }
                      },
                      child: const Text("Verificar"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
