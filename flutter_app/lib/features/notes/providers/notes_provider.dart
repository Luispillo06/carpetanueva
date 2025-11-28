import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/note.dart';
import '../data/notes_repository.dart';

/// Provider del repositorio
/// Tu compañero debe implementar NotesRepository con SQLite
/// Por ahora es una interfaz vacía
final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  throw UnimplementedError(
    'El compañero debe implementar NotesRepository con SQLite',
  );
});

/// StateNotifier que gestiona el estado de las notas
class NotesNotifier extends StateNotifier<AsyncValue<List<Note>>> {
  final NotesRepository repository;

  NotesNotifier(this.repository) : super(const AsyncValue.loading()) {
    // Cargar notas al inicializar
    _loadNotes();
  }

  /// Cargar todas las notas desde el repositorio
  Future<void> _loadNotes() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => repository.getAllNotes());
  }

  /// Crear una nueva nota
  Future<void> createNote(String title, String content) async {
    final newNote = Note(title: title, content: content);
    await repository.createNote(newNote);
    await _loadNotes(); // Recargar la lista
  }

  /// Actualizar una nota existente
  Future<void> updateNote(Note note) async {
    await repository.updateNote(note);
    await _loadNotes(); // Recargar la lista
  }

  /// Eliminar una nota
  Future<void> deleteNote(int id) async {
    await repository.deleteNote(id);
    await _loadNotes(); // Recargar la lista
  }

  /// Buscar notas por título o contenido
  Future<void> searchNotes(String query) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => repository.searchNotes(query));
  }

  /// Recargar todas las notas
  Future<void> refreshNotes() async {
    await _loadNotes();
  }
}

/// Provider del StateNotifier de notas
final notesProvider =
    StateNotifierProvider<NotesNotifier, AsyncValue<List<Note>>>((ref) {
      final repository = ref.watch(notesRepositoryProvider);
      return NotesNotifier(repository);
    });

/// Provider para obtener una nota específica por ID
final noteByIdProvider = FutureProvider.family<Note?, int>((ref, id) async {
  final repository = ref.watch(notesRepositoryProvider);
  return repository.getNoteById(id);
});

/// Provider para búsqueda de notas
final searchNotesProvider =
    StateProvider.family<AsyncValue<List<Note>>, String>((ref, query) {
      if (query.isEmpty) {
        return ref.watch(notesProvider);
      }
      // La búsqueda se maneja desde el Notifier
      return const AsyncValue.data([]);
    });
