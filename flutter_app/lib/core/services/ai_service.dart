import 'package:http/http.dart' as http;
import 'dart:convert';

/// Servicio para comunicarse con una API de IA
/// Este ejemplo usa la API de OpenAI (ChatGPT)
/// Puedes reemplazarlo con otra API según necesites
class AIService {
  // Reemplaza esto con tu API key real
  static const String _apiKey = 'tu-api-key-aqui';
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  /// Resumir un texto usando IA
  /// Retorna el resumen o un mensaje de error
  static Future<String> summarizeText(String text) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content':
                  'Eres un asistente experto en resumir textos. Resume el siguiente texto de manera clara y concisa, manteniendo la información más importante.',
            },
            {'role': 'user', 'content': 'Resume este texto:\n\n$text'},
          ],
          'temperature': 0.7,
          'max_tokens': 200,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final summary = data['choices'][0]['message']['content'];
        return summary;
      } else {
        throw Exception('Error en la API: ${response.statusCode}');
      }
    } catch (e) {
      return 'Error al resumir: $e';
    }
  }

  /// Mejorar la redacción de un texto usando IA
  static Future<String> improveText(String text) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content':
                  'Eres un experto en redacción y gramática. Mejora el siguiente texto: corrige errores, mejora la claridad, la coherencia y el estilo. Mantén el significado original.',
            },
            {'role': 'user', 'content': 'Mejora este texto:\n\n$text'},
          ],
          'temperature': 0.7,
          'max_tokens': 500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final improved = data['choices'][0]['message']['content'];
        return improved;
      } else {
        throw Exception('Error en la API: ${response.statusCode}');
      }
    } catch (e) {
      return 'Error al mejorar: $e';
    }
  }

  /// Generar ideas o sugerencias para expandir un texto
  static Future<String> generateIdeas(String text) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content':
                  'Eres un experto en creatividad. Genera 3-5 ideas para expandir o mejorar el siguiente texto.',
            },
            {
              'role': 'user',
              'content': 'Genera ideas para este texto:\n\n$text',
            },
          ],
          'temperature': 0.8,
          'max_tokens': 300,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final ideas = data['choices'][0]['message']['content'];
        return ideas;
      } else {
        throw Exception('Error en la API: ${response.statusCode}');
      }
    } catch (e) {
      return 'Error al generar ideas: $e';
    }
  }
}
