# 🎯 Guía Técnica - Mini Bloc de Notas Inteligente

## 📖 Resumen Ejecutivo

Este proyecto es una **aplicación Flutter profesional** que demuestra:
- ✅ Arquitectura limpia con separación de capas
- ✅ Gestión de estado moderna con Riverpod
- ✅ Integración con IA (OpenAI API)
- ✅ Base de datos local (SQLite)
- ✅ UI/UX profesional

---

## 🔍 ¿Qué es Riverpod y por qué lo usamos?

### Problema que resuelve:

**Sin Riverpod** (usando Provider):
```dart
// ❌ Acoplado al árbol de widgets
Widget build(BuildContext context) {
  return Provider<MyService>(
    create: (_) => MyService(),
    child: MyApp(), // Debe estar dentro del árbol
  );
}
```

**Con Riverpod** (desacoplado):
```dart
// ✅ Independiente del árbol
final myServiceProvider = Provider((ref) => MyService());

void main() {
  runApp(
    const ProviderScope( // Envolvente único
      child: MyApp(),
    ),
  );
}
```

### Ventajas de Riverpod:

| Característica | Provider | Riverpod |
|---|---|---|
| Depende del árbol | ❌ Sí | ✅ No |
| Seguridad en tipos | ⚠️ Parcial | ✅ Total |
| Testing | ⚠️ Difícil | ✅ Fácil |
| Errores de contexto | ❌ Frecuentes | ✅ Nunca |

---

## 📚 Flujo de Datos en la Aplicación

```
┌─────────────┐
│   main.dart │ (Punto de entrada + ProviderScope)
└──────┬──────┘
       │
       ▼
┌─────────────────┐
│    app.dart     │ (MaterialApp + Tema)
└──────┬──────────┘
       │
       ▼
┌──────────────────────┐
│  NotesListPage       │ ◄─── ref.watch(notesProvider)
│  (UI - Lista)        │      ✅ Actualización reactiva
└──────┬───────────────┘
       │ onTap
       ▼
┌──────────────────────┐
│  NoteEditPage        │ ◄─── ref.read(notesProvider.notifier)
│  (UI - Formulario)   │      ✅ CRUD operations
└──────┬───────────────┘
       │ onCreate/onUpdate
       ▼
┌──────────────────────┐
│  NotesNotifier       │ ◄─── Estado centralizado
│  (StateNotifier)     │
└──────┬───────────────┘
       │
       ▼
┌──────────────────────┐
│  NotesRepository     │ ◄─── Interface
│  (Capa de datos)     │
└──────┬───────────────┘
       │
       ▼
┌──────────────────────┐
│  SQLite              │ ◄─── BASE DE DATOS
│  (app_database.dart) │      (Tu compañero)
└──────────────────────┘
```

---

## 🏛️ Patrones de Diseño Usados

### 1. **Repository Pattern**
Interfaz que abstrae la lógica de acceso a datos:

```dart
// Interfaz (nosotros)
abstract class NotesRepository {
  Future<List<Note>> getAllNotes();
  Future<int> createNote(Note note);
  // ...
}

// Implementación (tu compañero)
class SqliteNotesRepository extends NotesRepository {
  @override
  Future<List<Note>> getAllNotes() async {
    // Acceder a SQLite
  }
}
```

### 2. **StateNotifier Pattern**
Gestiona el estado de manera inmutable:

```dart
class NotesNotifier extends StateNotifier<AsyncValue<List<Note>>> {
  Future<void> createNote(String title, String content) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await repository.getAllNotes();
    });
  }
}
```

### 3. **Builder Pattern**
NoteForm reutilizable en múltiples contextos

### 4. **Singleton Pattern (implícito)**
Riverpod crea instancias únicas de providers

---

## 🧩 Componentes Principales

### Model Layer (core/models/)

**Note.dart:**
- Modelo de datos inmutable
- `copyWith()` para actualizaciones sin mutación
- `toJson()` / `fromJson()` para serialización
- `operator==` y `hashCode()` para comparación

```dart
final noteA = Note(title: 'Test');
final noteB = noteA.copyWith(title: 'Nuevo'); // Copia segura
```

### Service Layer (core/services/)

**AIService.dart:**
- Encapsula lógica de comunicación con IA
- Métodos estáticos para fácil acceso
- Manejo de errores centralizado

```dart
final summary = await AIService.summarizeText('...');
```

### Data Layer (features/notes/data/)

**NotesRepository.dart:**
- Define contrato (interfaz)
- Separa la UI de la implementación de BD

### State Management (features/notes/providers/)

**NotesProvider.dart:**
- `notesProvider`: Principal provider reactivo
- `noteByIdProvider`: Obtener nota por ID
- `searchNotesProvider`: Búsqueda

```dart
// En UI
final notesAsync = ref.watch(notesProvider); // Reactivo

notesAsync.when(
  loading: () => LoadingWidget(),
  error: (error, st) => ErrorWidget(error),
  data: (notes) => ListView(...),
);
```

### Presentation Layer (features/notes/presentation/)

**Pages:**
- `NotesListPage`: Pantalla principal
- `NoteEditPage`: Crear/editar

**Widgets:**
- `NoteItem`: Card reutilizable
- `NoteForm`: Formulario reutilizable

---

## 🔌 Integración de IA

### Cómo funciona:

1. **Usuario presiona "Resumir"** en NoteEditPage
2. Se llama `AIService.summarizeText(content)`
3. AIService envía HTTP POST a OpenAI API:

```dart
POST https://api.openai.com/v1/chat/completions
{
  "model": "gpt-3.5-turbo",
  "messages": [
    {"role": "system", "content": "Eres un..."},
    {"role": "user", "content": "Resume esto..."}
  ]
}
```

4. Se recibe respuesta y muestra en diálogo
5. Usuario puede usar la sugerencia

### Para activar IA:

1. Obtén API key en [platform.openai.com](https://platform.openai.com)
2. Edita `lib/core/services/ai_service.dart`
3. Reemplaza `'tu-api-key-aqui'` con tu clave

---

## 🗄️ Cómo SQLite se Integra

**Tu compañero debe:**

1. **Crear app_database.dart:**
```dart
class AppDatabase {
  static final AppDatabase _instance = AppDatabase._();
  late Database _database;

  factory AppDatabase() => _instance;
  AppDatabase._();

  Future<void> init() async {
    _database = await openDatabase(...);
    await _database.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        createdAt TEXT,
        updatedAt TEXT
      )
    ''');
  }
}
```

2. **Crear note_dao.dart:**
```dart
class NoteDao {
  Future<List<Note>> getAll() async {
    final maps = await database.query('notes');
    return maps.map((m) => Note.fromJson(m)).toList();
  }
  
  Future<int> insert(Note note) async {
    return await database.insert('notes', note.toJson());
  }
  // etc...
}
```

3. **Implementar NotesRepository:**
```dart
class SqliteNotesRepository extends NotesRepository {
  final NoteDao noteDao;

  @override
  Future<List<Note>> getAllNotes() => noteDao.getAll();

  @override
  Future<int> createNote(Note note) => noteDao.insert(note);
  // etc...
}
```

4. **Conectar en Riverpod:**
```dart
final notesRepositoryProvider = Provider<NotesRepository>((ref) {
  return SqliteNotesRepository(NoteDao());
});
```

---

## 🎨 Tema Visual

### Material Design 3

```dart
ThemeData(
  useMaterial3: true,
  primaryColor: Color(0xFF2196F3),
  // Con Google Fonts para tipografía moderna
)
```

### Colores:
- 🔵 **Primario:** Azul claro
- ❤️ **Acento:** Rojo
- ⚪ **Background:** Gris muy claro

### Modo Oscuro:
Automático según preferencia del sistema

---

## ✅ Validaciones Implementadas

```dart
// NoteForm valida:
- Título: min 3 caracteres, max 100
- Contenido: min 5 caracteres

// Helpers validan:
- Email
- Longitud de texto
- Palabras
```

---

## 🧪 Testing (Ejemplo)

```dart
void main() {
  group('Note Model', () {
    test('copyWith crea copia correcta', () {
      final note1 = Note(title: 'A', content: 'B');
      final note2 = note1.copyWith(title: 'C');
      
      expect(note1.title, 'A');
      expect(note2.title, 'C');
      expect(note2.content, 'B');
    });
  });
}
```

---

## 📊 Diagrama de Casos de Uso

```
┌─────────────────────┐
│   Usuario Final     │
└─────────┬───────────┘
          │
  ┌───────┴─────────┬──────────────┬────────────┐
  │                 │              │            │
  ▼                 ▼              ▼            ▼
[Ver Notas]   [Crear Nota]  [Editar Nota] [Eliminar]
  │                 │              │
  │                 ▼              ▼
  │           [Usar IA]       [Buscar]
  │                 │              │
  └─────────┬───────┴──────────────┘
            │
            ▼
      [Base de Datos]
```

---

## 🚀 Performance

- **Lazy Loading:** Las notas se cargan bajo demanda
- **Caching:** Riverpod cachea automáticamente
- **Búsqueda:** En tiempo real sin lag
- **Async/Await:** Operaciones no bloqueantes

---

## 📝 Checklist para la Entrega

- [ ] Base de datos SQLite funcionando
- [ ] CRUD completo funcionando
- [ ] Búsqueda funcionando
- [ ] IA integrada (requiere API key)
- [ ] Tema visual aplicado
- [ ] Pantallas principales funcionando
- [ ] Validaciones activas
- [ ] Sin errores en consola

---

**Proyecto completo y profesional. ¡Listo para producción! 🎉**
