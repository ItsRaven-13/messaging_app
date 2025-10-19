class PhoneValidator {
  static String? validate(String? input) {
    if (input == null || input.isEmpty) {
      return 'El número es obligatorio';
    }
    final regex = RegExp(r'^[0-9]{10}$');
    if (!regex.hasMatch(input)) {
      return 'Número inválido. Use formato (XXXXXXXXXX)';
    }
    return null;
  }
}
