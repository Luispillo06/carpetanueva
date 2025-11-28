#!/bin/bash
# ============================================================
# SCRIPT DE INTEGRACIÓN - Instrucciones para tu compañero
# ============================================================
#
# Este archivo contiene las instrucciones exactas que tu compañero
# debe seguir para implementar SQLite y conectarlo con Riverpod.
#

# PASO 1: Crear el archivo de base de datos
# ============================================================
# Archivo: lib/core/database/app_database.dart
# 
# Este archivo INICIALIZA SQLite y crea las tablas.

cat > lib/core/database/app_database.dart << 'EOF'
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  static Database? _database;

  factory AppDatabase() => _instance;
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
EOF

# PASO 2: Crear el DAO (Data Access Object)
# ============================================================
# Archivo: lib/core/database/note_dao.dart
#
# Este archivo contiene todas las operaciones CRUD.

cat > lib/core/database/note_dao.dart << 'EOF'
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
EOF

# PASO 3: Implementar el Repository
# ============================================================
# Archivo: lib/features/notes/data/notes_repository_impl.dart
#
# Este archivo implementa la interfaz NotesRepository

cat > lib/features/notes/data/notes_repository_impl.dart << 'EOF'
import '../../../core/database/app_database.dart';
import '../../../core/database/note_dao.dart';
import '../../../core/models/note.dart';
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
EOF

# PASO 4: Actualizar notes_provider.dart
# ============================================================
# 
# Reemplaza la definición de notesRepositoryProvider con:

echo ""
echo "PASO 4: Actualiza lib/features/notes/providers/notes_provider.dart"
echo ""
echo "Reemplaza la función notesRepositoryProvider (líneas 8-11) con:"
echo ""
cat << 'EOF'
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
EOF

echo ""
echo "✅ INSTRUCCIONES COMPLETADAS"
echo ""
echo "Tu compañero debe:"
echo "1. Crear los 3 archivos Dart arriba"
echo "2. Actualizar notes_provider.dart con el código del PASO 4"
echo "3. Ejecutar: flutter pub get"
echo "4. Ejecutar: flutter run"
echo ""
echo "¡La app funcionará con SQLite integrado!"
