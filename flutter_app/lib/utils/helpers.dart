import 'package:intl/intl.dart';

/// Funciones auxiliares y helpers de la aplicación

/// Formatear fecha a string legible
String formatDate(DateTime date) {
  final formatter = DateFormat('dd/MM/yyyy');
  return formatter.format(date);
}

/// Formatear fecha y hora
String formatDateTime(DateTime dateTime) {
  final formatter = DateFormat('dd/MM/yyyy HH:mm');
  return formatter.format(dateTime);
}

/// Obtener tiempo relativo (ej: "hace 2 horas")
String getRelativeTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return 'hace unos momentos';
  } else if (difference.inMinutes < 60) {
    return 'hace ${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''}';
  } else if (difference.inHours < 24) {
    return 'hace ${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
  } else if (difference.inDays < 7) {
    return 'hace ${difference.inDays} día${difference.inDays > 1 ? 's' : ''}';
  } else {
    return formatDate(dateTime);
  }
}

/// Obtener el número de palabras en un texto
int getWordCount(String text) {
  return text.trim().split(RegExp(r'\s+')).length;
}

/// Obtener el número de caracteres (sin espacios)
int getCharacterCount(String text) {
  return text.replaceAll(RegExp(r'\s'), '').length;
}

/// Truncar texto a una longitud máxima
String truncateText(String text, int maxLength) {
  if (text.length <= maxLength) {
    return text;
  }
  return '${text.substring(0, maxLength)}...';
}

/// Verificar si el texto es válido para una nota
bool isValidNoteText(String text) {
  return text.trim().isNotEmpty && text.length >= 5;
}

/// Validar título de nota
bool isValidNoteTitle(String title) {
  return title.trim().isNotEmpty && title.length >= 3 && title.length <= 100;
}
