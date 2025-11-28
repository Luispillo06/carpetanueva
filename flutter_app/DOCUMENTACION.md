# 📱 Mini Bloc de Notas Inteligente

## 📋 Descripción del Proyecto

Aplicación móvil Flutter que permite crear, editar y listar notas con una base de datos local SQLite. Incluye funciones de IA para resumir y mejorar el contenido de las notas.

---

## 🏗️ Arquitectura General

### Estructura de Carpetas

```
lib/
├── main.dart                          # Punto de entrada + ProviderScope
├── app/
│   └── app.dart                       # MaterialApp + Tema
├── config/
│   └── theme.dart                     # Configuración de temas (luz/oscuro)
├── core/
│   ├── models/
│   │   └── note.dart                  # Modelo Note (copyWith, toJson, fromJson)
│   ├── services/
│   │   └── ai_service.dart            # Servicio de IA (OpenAI API)
│   └── database/
│       ├── app_database.dart          # [COMPAÑERO: Inicializar SQLite]
│       └── note_dao.dart              # [COMPAÑERO: Operaciones CRUD]
├── features/
│   └── notes/
│       ├── data/
│       │   └── notes_repository.dart   # Interfaz del repositorio
│       ├── providers/
│       │   └── notes_provider.dart     # Riverpod StateNotifier (CRUD + búsqueda)
│       └── presentation/
│           ├── pages/
│           │   ├── notes_list_page.dart    # Pantalla principal
│           │   └── note_edit_page.dart     # Crear/editar + botones IA
│           └── widgets/
│               ├── note_item.dart          # Card de nota
│               └── note_form.dart          # Formulario de entrada
└── utils/
    └── helpers.dart                    # Funciones auxiliares (formateo, validación)
```

---

## 🔧 Detalles Técnicos

### 1. **Base de Datos SQLite** (Responsable: Compañero)

**Interfaz esperada en `NotesRepository`:**

```dart
abstract class NotesRepository {
  Future<List<Note>> getAllNotes();
  Future<Note?> getNoteById(int id);
  Future<int> createNote(Note note);
  Future<void> updateNote(Note note);
  Future<void> deleteNote(int id);
  Future<List<Note>> searchNotes(String query);
  Future<void> deleteAllNotes();
}
```

**Tabla esperada:**
```sql
CREATE TABLE notes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  createdAt TEXT NOT NULL,
  updatedAt TEXT
)
```

---

### 2. **Gestión de Estado con Riverpod**

**¿Por qué Riverpod?**
- ✅ No depende del árbol de widgets (más seguro)
- ✅ Reactividad automática (actualiza UI cuando cambian datos)
- ✅ Separación clara entre lógica y UI
- ✅ Fácil de probar
- ✅ Escalable a proyectos grandes

**Providers creados:**

1. **`notesRepositoryProvider`** → Proporciona la instancia del repositorio
2. **`notesProvider`** → StateNotifier que maneja:
   - Cargar notas
   - Crear nota
   - Actualizar nota
   - Eliminar nota
   - Buscar notas
3. **`noteByIdProvider`** → Obtener una nota específica
4. **`searchNotesProvider`** → Búsqueda por query

**Uso en UI:**
```dart
final notesAsync = ref.watch(notesProvider);
ref.read(notesProvider.notifier).createNote(title, content);
```

---

### 3. **Servicio de IA**

**Funciones disponibles:**

```dart
// Resumir texto
AIService.summarizeText(String text) → Future<String>

// Mejorar redacción
AIService.improveText(String text) → Future<String>

// Generar ideas
AIService.generateIdeas(String text) → Future<String>
```

**API usada:** OpenAI ChatGPT (requiere API key)

**Configuración:**
- Edita `lib/core/services/ai_service.dart`
- Reemplaza `tu-api-key-aqui` con tu clave real

---

## 📱 Pantallas Implementadas

### 1️⃣ **Pantalla de Lista (NotesListPage)**
- ✅ Muestra todas las notas
- ✅ Búsqueda en tiempo real
- ✅ Botón para crear nota
- ✅ Eliminar nota con confirmación
- ✅ Editar nota al hacer tap
- ✅ Mensaje vacío cuando no hay notas

### 2️⃣ **Pantalla de Edición (NoteEditPage)**
- ✅ Crear nueva nota
- ✅ Editar nota existente
- ✅ Formulario con validación
- ✅ Botones de IA (Resumir, Mejorar)
- ✅ Mostrar resultados en diálogos
- ✅ Opción de usar sugerencia de IA

### 3️⃣ **Widgets**
- ✅ **NoteItem**: Card reutilizable
- ✅ **NoteForm**: Formulario reutilizable

---

## 🎨 Tema Visual

**Colors:**
- 🔵 Primario: `#2196F3` (Azul)
- ❤️ Acentos: `#FF6B6B` (Rojo)
- ⚪ Background: `#F5F5F5` (Gris claro)

**Tipografía:** Google Fonts (Roboto)

**Modo oscuro:** Soporte automático

---

## 🚀 Cómo Ejecutar

1. **Instalar dependencias:**
   ```bash
   flutter pub get
   ```

2. **Ejecutar la app:**
   ```bash
   flutter run
   ```

3. **Compilar para Android:**
   ```bash
   flutter build apk
   ```

4. **Compilar para iOS:**
   ```bash
   flutter build ios
   ```

---

## 🤖 Uso de IA en el Proyecto

### Funcionalidades:

1. **Resumir Nota**
   - Prompt: "Eres un asistente experto en resumir textos..."
   - Usa GPT-3.5-turbo
   - Max tokens: 200

2. **Mejorar Redacción**
   - Prompt: "Eres un experto en redacción y gramática..."
   - Corrige ortografía, claridad y coherencia
   - Max tokens: 500

3. **Generar Ideas**
   - Prompt: "Eres un experto en creatividad..."
   - Genera 3-5 ideas para expandir
   - Max tokens: 300

---

## 🧪 Pruebas

```dart
// Test de creación de nota
test('Crear nota exitosa', () async {
  final note = Note(title: 'Test', content: 'Contenido');
  expect(note.title, 'Test');
  expect(note.id, null);
});

// Test de validación
test('Título inválido', () {
  expect(isValidNoteTitle('ab'), false); // < 3 caracteres
  expect(isValidNoteTitle('Válido'), true);
});
```

---

## 📦 Dependencias Principales

```yaml
flutter_riverpod: ^2.4.0      # State management
sqflite: ^2.3.0               # SQLite
http: ^1.1.0                  # Peticiones HTTP (IA)
google_fonts: ^6.1.0          # Fuentes
intl: ^0.19.0                 # Internacionalización
```

---

## 🐛 Problemas Comunes

### Error: "Target of URI doesn't exist"
- Solución: Ejecuta `flutter pub get` primero

### Error de API de IA
- Verifica tu API key
- Comprueba límite de créditos en OpenAI

### Notas no se guardan
- Asegúrate de que tu compañero implementó el repository
- Verifica que SQLite está inicializado

---

## 📝 Plan de Desarrollo

- [x] Crear estructura del proyecto
- [x] Implementar modelo Note
- [x] Crear providers de Riverpod
- [x] Crear UI (lista, formulario)
- [x] Integrar servicio de IA
- [ ] Tu compañero: Implementar SQLite + DAO
- [ ] Tu compañero: Implementar NotesRepository
- [ ] Testing
- [ ] Publicar en tiendas

---

## 👥 Responsabilidades del Equipo

### Tú (UI + Lógica)
- ✅ Crear pantallas
- ✅ Gestión de estado con Riverpod
- ✅ Integración de IA
- ✅ Validaciones y helpers

### Compañero (BD)
- ⬜ Crear `app_database.dart`
- ⬜ Crear `note_dao.dart`
- ⬜ Implementar `NotesRepository`
- ⬜ Conectar con tu código

---

## 📞 Referencias Útiles

- [Flutter Riverpod](https://riverpod.dev)
- [SQLite con Flutter](https://pub.dev/packages/sqflite)
- [OpenAI API](https://platform.openai.com/docs)
- [Material Design 3](https://m3.material.io)

---

**¡Proyecto listo! ¡Que disfrutes desarrollando! 🎉**
