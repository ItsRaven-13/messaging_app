import 'package:go_router/go_router.dart';

T requireExtra<T>(GoRouterState state) {
  final extra = state.extra;
  if (extra is! T) {
    throw Exception("Se esperaba un extra de tipo $T en ${state.uri}");
  }
  return extra;
}

class OtpVerificationArgs {
  final String phoneNumber;
  final String? autodetectedSmsCode;
  OtpVerificationArgs(this.phoneNumber, {this.autodetectedSmsCode});
}
