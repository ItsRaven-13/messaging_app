class PhoneValidator {
  static String? validate(String? input) {
    if (input == null || input.isEmpty) {
      return 'El número es obligatorio';
    }
    final regex = RegExp(r'^77[0-9]{8}$');
    if (!regex.hasMatch(input)) {
      return 'Número inválido. Use formato  (77XXXXXXXX)';
    }
    return null;
  }
}
