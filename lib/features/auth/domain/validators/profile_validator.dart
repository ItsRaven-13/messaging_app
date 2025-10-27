class ProfileValidator {
  static String? validate(String? name) {
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
