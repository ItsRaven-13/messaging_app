class OtpValidator {
  static String? isValid(String? otp) {
    if (otp == null || otp.isEmpty) {
      return 'El código es obligatorio';
    }
    final regex = RegExp(r'^[0-9]{6}$');
    if (!regex.hasMatch(otp)) {
      return 'Código inválido. Debe tener 6 dígitos numéricos';
    }
    return null;
  }
}
