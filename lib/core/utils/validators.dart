String? validateEmail(String? value) {
  if (value == null || value.isEmpty) return 'O e-mail é obrigatório.';
  final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) return 'E-mail inválido.';
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) return 'A senha é obrigatória.';
  if (value.length < 6) return 'A senha deve ter pelo menos 6 caracteres.';
  return null;
}

String? validateRequired(String? value, [String fieldName = 'Este campo']) {
  if (value == null || value.trim().isEmpty) return '$fieldName é obrigatório.';
  return null;
}
