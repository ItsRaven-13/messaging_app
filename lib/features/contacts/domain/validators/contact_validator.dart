class ContactValidator {
  static String? phoneValidate(String? input) {
    if (input == null || input.isEmpty) {
      return 'El número es obligatorio';
    }
    final regex = RegExp(r'^[0-9]{10}$');
    if (!regex.hasMatch(input)) {
      return 'Número inválido. Use formato (XXXXXXXXXX)';
    }
    return null;
  }

  static String? nameValidate(String? name) {
    if (name == null || name.isEmpty) {
      return 'El nombre es obligatorio';
    }
    final regex = RegExp(r'^[a-zA-Z\s]+$');
    if (!regex.hasMatch(name)) {
      return 'Nombre inválido. Solo se permiten letras y espacios';
    }
    return null;
  }
}
