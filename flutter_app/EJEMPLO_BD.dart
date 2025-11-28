// ARCHIVO DE EJEMPLO PARA TU COMPAÑERO
// =====================================
//
// Este archivo muestra EXACTAMENTE cómo debe implementar SQLite
// Tu compañero debe crear estos archivos en:
// - lib/core/database/app_database.dart
// - lib/core/database/note_dao.dart
// - lib/features/notes/data/notes_repository_impl.dart

/*

### PASO 1: app_database.dart (Inicializar SQLite)

```dart
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  static Database? _database;

  factory AppDatabase() {
    return _instance;
  }

  AppDatabase._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notes_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT
      )
    ''');
  }
}
```

### PASO 2: note_dao.dart (Operaciones CRUD)

```dart
import 'package:sqflite/sqflite.dart';
import '../../core/models/note.dart';
import 'app_database.dart';

class NoteDao {
  final AppDatabase appDatabase;

  NoteDao(this.appDatabase);

  Future<List<Note>> getAllNotes() async {
    final db = await appDatabase.database;
    final maps = await db.query('notes', orderBy: 'createdAt DESC');
    return maps.map((map) => Note.fromJson(map)).toList();
  }

  Future<Note?> getNoteById(int id) async {
    final db = await appDatabase.database;
    final maps = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return Note.fromJson(maps.first);
  }

  Future<int> insertNote(Note note) async {
    final db = await appDatabase.database;
    return await db.insert('notes', note.toJson());
  }

  Future<int> updateNote(Note note) async {
    final db = await appDatabase.database;
    return await db.update(
      'notes',
      note.toJson(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await appDatabase.database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Note>> searchNotes(String query) async {
    final db = await appDatabase.database;
    final maps = await db.query(
      'notes',
      where: 'title LIKE ? OR content LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'createdAt DESC',
    );

    return maps.map((map) => Note.fromJson(map)).toList();
  }

  Future<void> deleteAllNotes() async {
    final db = await appDatabase.database;
    await db.delete('notes');
  }
}
```

### PASO 3: notes_repository_impl.dart (Implementación)

```dart
import 'package:flutter_app/core/database/app_database.dart';
import 'package:flutter_app/core/database/note_dao.dart';
import 'package:flutter_app/core/models/note.dart';
import 'notes_repository.dart';

class SqliteNotesRepository extends NotesRepository {
  final NoteDao noteDao;

  SqliteNotesRepository({required this.noteDao});

  @override
  Future<List<Note>> getAllNotes() async {
    return await noteDao.getAllNotes();
  }

  @override
  Future<Note?> getNoteById(int id) async {
    return await noteDao.getNoteById(id);
  }

  @override
  Future<int> createNote(Note note) async {
    return await noteDao.insertNote(note);
  }

  @override
  Future<void> updateNote(Note note) async {
    await noteDao.updateNote(note);
  }

  @override
  Future<void> deleteNote(int id) async {
    await noteDao.deleteNote(id);
  }

  @override
  Future<List<Note>> searchNotes(String query) async {
    return await noteDao.searchNotes(query);
  }

  @override
  Future<void> deleteAllNotes() async {
    await noteDao.deleteAllNotes();
  }
}
```

### PASO 4: Conectar con Riverpod (en notes_provider.dart)

Modifica el provider para que use tu implementación:

```dart
// Cambia esto:
final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  throw UnimplementedError(
    'El compañero debe implementar NotesRepository con SQLite',
  );
});

// Por esto:
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final noteDaoProvider = Provider<NoteDao>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return NoteDao(database);
});

final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  final noteDao = ref.watch(noteDaoProvider);
  return SqliteNotesRepository(noteDao: noteDao);
});
```

*/

print("✅ Tu compañero debe seguir estos pasos exactos");
