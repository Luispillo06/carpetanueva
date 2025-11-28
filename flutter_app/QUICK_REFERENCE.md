# ⚡ REFERENCIA RÁPIDA - Mini Bloc de Notas

## 📍 Ubicación de Archivos Importantes

```
flutter_app/
├── 📖 DOCUMENTACION.md          ← Leer PRIMERO
├── 📖 GUIA_TECNICA.md           ← Entender arquitectura
├── 📖 EJEMPLO_BD.dart           ← Tu compañero: SQLite
├── 📖 RESUMEN_FINAL.md          ← Estado del proyecto
│
├── pubspec.yaml                 ← Dependencias
├── lib/
│   ├── main.dart                ← Punto de entrada
│   ├── app/app.dart             ← MaterialApp
│   ├── config/theme.dart        ← Temas
│   ├── core/
│   │   ├── models/note.dart     ← Modelo de datos
│   │   └── services/ai_service.dart  ← IA
│   ├── features/notes/
│   │   ├── data/notes_repository.dart  ← Interfaz BD
│   │   ├── providers/notes_provider.dart  ← Riverpod (IMPORTANTE)
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── notes_list_page.dart
│   │       │   └── note_edit_page.dart
│   │       └── widgets/
│   │           ├── note_item.dart
│   │           └── note_form.dart
│   └── utils/helpers.dart       ← Funciones auxiliares
```

---

## 🎯 Flujo Rápido

### 1️⃣ Ver Notas
```
NotesListPage → ref.watch(notesProvider) → Muestra lista
```

### 2️⃣ Crear Nota
```
NoteEditPage → NoteForm.onSubmit() → ref.read(notesProvider.notifier).createNote()
```

### 3️⃣ Usar IA
```
NoteEditPage → "Resumir" → AIService.summarizeText() → Diálogo con resultado
```

### 4️⃣ Guardar en BD (Tu compañero)
```
notesProvider → repository.createNote() → noteDao.insertNote() → SQLite
```

---

## 🔑 Conceptos Clave

| Concepto | Uso | Archivo |
|----------|-----|---------|
| **Note** | Modelo de datos | core/models/note.dart |
| **Riverpod** | Gestión de estado | features/notes/providers/notes_provider.dart |
| **Repository** | Abstracción de BD | features/notes/data/notes_repository.dart |
| **AIService** | Llamadas a IA | core/services/ai_service.dart |
| **ConsumerWidget** | Widget con Riverpod | pages/notes_list_page.dart |
| **NotesNotifier** | Lógica de estado | features/notes/providers/notes_provider.dart |

---

## ⚙️ Configuración Básica

### ✅ Instalar dependencias
```bash
flutter pub get
```

### ✅ Agregar API key de IA
Edita `lib/core/services/ai_service.dart` línea 10:
```dart
static const String _apiKey = 'sk-...'; // Tu clave
```

### ✅ Ejecutar app
```bash
flutter run
```

---

## 🤝 División de Trabajo

### ✅ Tú (Responsabilidad: COMPLETADA)
- [x] Estructura del proyecto
- [x] Modelos y validaciones
- [x] Riverpod providers
- [x] UI (pantallas y widgets)
- [x] Integración con IA
- [x] Temas y estilos

### ⏳ Tu Compañero (Responsabilidad: PENDIENTE)
- [ ] `lib/core/database/app_database.dart` - Iniciar SQLite
- [ ] `lib/core/database/note_dao.dart` - CRUD operations
- [ ] `lib/features/notes/data/notes_repository_impl.dart` - Implementación
- [ ] Conectar providers (modificar `notes_provider.dart`)

Ver `EJEMPLO_BD.dart` para código exacto

---

## 🧪 Pruebas Manuales

### Test 1: Crear nota
1. Abre app → Presiona ➕
2. Ingresa título y contenido
3. Presiona "Crear Nota"
4. ✅ Aparece en lista

### Test 2: Editar nota
1. Toca una nota
2. Cambia título o contenido
3. Presiona "Actualizar Nota"
4. ✅ Cambios aparecen

### Test 3: Buscar
1. Escribe en buscador
2. ✅ Lista se filtra

### Test 4: Eliminar
1. Toca nota en lista
2. Presiona ➖ (icono de eliminar)
3. Confirma
4. ✅ Nota desaparece

### Test 5: IA (requiere API key)
1. Crea nota con contenido
2. Presiona "Resumir con IA"
3. ✅ Muestra resumen en diálogo

---

## 🐛 Errores Comunes

| Error | Solución |
|-------|----------|
| "Target of URI doesn't exist" | Ejecuta `flutter pub get` |
| "No implements NotesRepository" | Tu compañero debe implementar |
| "API error" en IA | Verifica API key en `ai_service.dart` |
| "Notas no se guardan" | Espera a que tu compañero implemente SQLite |

---

## 📚 Documentación Detallada

- **DOCUMENTACION.md** - Especificación completa
- **GUIA_TECNICA.md** - Explicación arquitectónica
- **EJEMPLO_BD.dart** - Código SQLite listo para copiar
- **README.md** - Introducción y setup

---

## 🎓 Aprendizaje

Si quieres entender mejor:

1. **Riverpod:** Lee `GUIA_TECNICA.md` sección "¿Qué es Riverpod?"
2. **Flujo de datos:** Ver diagrama en `GUIA_TECNICA.md`
3. **SQLite:** Ver `EJEMPLO_BD.dart` para implementación exacta
4. **IA:** Ver `core/services/ai_service.dart` para prompts

---

## ✅ Checklist Final

- [ ] Ejecuté `flutter pub get`
- [ ] Copié API key de OpenAI
- [ ] Agregué API key en `ai_service.dart`
- [ ] Ejecuté `flutter run`
- [ ] Probé crear, editar, eliminar notas
- [ ] Probé búsqueda
- [ ] Mi compañero implementó SQLite
- [ ] Probé funciones de IA
- [ ] Todo funciona ✅

---

## 🚀 Próximos Pasos

1. **Ahora:** Tu compañero implementa BD
2. **Después:** Testing unitario
3. **Luego:** Testing UI
4. **Finalmente:** Publicar en Play Store/App Store

---

## 📞 Dudas Frecuentes

**P: ¿Dónde está la base de datos?**
R: Tu compañero la implementa. Ver `EJEMPLO_BD.dart`

**P: ¿Cómo activo la IA?**
R: Agrega tu API key en `lib/core/services/ai_service.dart`

**P: ¿Puedo cambiar los colores?**
R: Sí, edita `lib/config/theme.dart`

**P: ¿Cómo agregó más campos a las notas?**
R: Modifica `Note` en `core/models/note.dart`

---

**Proyecto de referencia profesional. ¡Buen trabajo!** 🎉
