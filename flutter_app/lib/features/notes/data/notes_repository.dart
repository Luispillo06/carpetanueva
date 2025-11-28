import '../../core/models/note.dart';

/// Interfaz del repositorio de notas
/// Tu compañero implementará esto con SQLite
abstract class NotesRepository {
  /// Obtener todas las notas
  Future<List<Note>> getAllNotes();

  /// Obtener una nota por ID
  Future<Note?> getNoteById(int id);

  /// Crear una nueva nota
  Future<int> createNote(Note note);

  /// Actualizar una nota existente
  Future<void> updateNote(Note note);

  /// Eliminar una nota
  Future<void> deleteNote(int id);

  /// Buscar notas por título o contenido
  Future<List<Note>> searchNotes(String query);

  /// Eliminar todas las notas (opcional)
  Future<void> deleteAllNotes();
}
