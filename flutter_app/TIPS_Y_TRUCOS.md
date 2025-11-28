# 💡 TIPS Y TRUCOS - Mini Bloc de Notas

## 🎨 Personalización

### Cambiar colores

Edita `lib/config/theme.dart`:

```dart
static const Color primaryColor = Color(0xFF2196F3); // ← Aquí
```

Busca colores en: https://material.io/resources/color

### Cambiar fuente

En `lib/config/theme.dart`:

```dart
textTheme: GoogleFonts.robotoTextTheme( // ← Cambia a otra
  // poppinsTextTheme, latoTextTheme, etc...
)
```

### Agregar más campos a las notas

1. Edita `lib/core/models/note.dart`
2. Agrega campos al modelo
3. Actualiza `toJson()` y `fromJson()`
4. Tu compañero actualiza la tabla SQLite

---

## 🚀 Optimizaciones

### Lazy Loading

Riverpod lo hace automáticamente. Las notas se cargan solo cuando se acceden.

### Búsqueda más rápida

Actualmente busca en memoria. Para BD grande:

```dart
// Envía búsqueda a SQLite en lugar de filtrar en memoria
Future<void> searchNotes(String query) async {
  // Delega a repository.searchNotes(query)
}
```

### Cache de Imágenes

Si agregas imágenes de notas:

```dart
image_cache: const CircleAvatar(
  backgroundImage: CachedNetworkImageProvider('url'),
)
```

---

## 🧪 Testing

### Test unitario de modelo

```dart
test('Note.copyWith crea copia correcta', () {
  final note1 = Note(title: 'A', content: 'B');
  final note2 = note1.copyWith(title: 'C');
  
  expect(note1.title, 'A');
  expect(note2.title, 'C');
  expect(note2.content, 'B');
});
```

### Test de provider

```dart
test('notesProvider carga notas', () async {
  final container = ProviderContainer();
  
  final notes = await container.read(notesProvider.future);
  
  expect(notes, isNotEmpty);
});
```

---

## 🐛 Debugging

### Ver estado de Riverpod

Agrega Riverpod DevTools:

```yaml
dev_dependencies:
  riverpod_generator: ^2.0.0
```

### Ver logs

```dart
print('📌 Debug: $value');
debugPrint('📌 Debug: $value');
```

### Inspectar widgets

Usa Flutter DevTools:

```bash
flutter pub global activate devtools
devtools
```

---

## 📱 Compilación

### Android Debug

```bash
flutter run
```

### Android Release

```bash
flutter build apk --release
```

### iOS Debug

```bash
flutter run -d iphone
```

### iOS Release

```bash
flutter build ios --release
```

---

## 🌐 Distribuir

### Play Store (Android)

1. Crear cuenta de desarrollador
2. Compilar APK con `flutter build apk --release`
3. Subir a Google Play Console

### App Store (iOS)

1. Crear cuenta de desarrollador Apple
2. Compilar con `flutter build ios --release`
3. Usar Xcode para subir

---

## ⚡ Performance

### Reducir tamaño de app

```bash
flutter build apk --release --split-per-abi
```

### Mejorar velocidad de scroll

```dart
ListView.builder( // Ya lo usas ✅
  itemCount: notes.length,
  itemBuilder: (context, index) => NoteItem(...),
)
```

### Caching de providers

Riverpod cachea automáticamente. Para limpiar:

```dart
ref.invalidate(notesProvider);
```

---

## 🤝 Trabajo Colaborativo

### Git workflow

```bash
# Tu compañero crea rama para BD
git checkout -b feature/sqlite-implementation

# Implementa y hace commit
git commit -m "feat: Implementar SQLite para notas"

# Pushea
git push origin feature/sqlite-implementation

# Crea Pull Request en GitHub
```

### Conflictos

Si tu compañero modifica `notes_provider.dart`:

```bash
git pull origin main
# Resuelve conflictos
git add .
git commit -m "Merge branch"
```

---

## 📚 Agregar Más Funcionalidades

### Agregar etiquetas (tags)

1. Agrega campo `tags: List<String>` a Note
2. Crea provider para filtrar por tag
3. UI para seleccionar tags

### Agregar recordatorios

1. Agrega campo `reminder: DateTime?` a Note
2. Usa `flutter_local_notifications`
3. Programa notificaciones

### Agregar sincronización en la nube

1. Usa Firebase Firestore
2. Sincroniza SQLite con Firestore
3. Manejo offline/online

---

## 🛡️ Seguridad

### Proteger API key

```dart
// ❌ MAL
static const String _apiKey = 'sk-xxx';

// ✅ BIEN
final apiKey = dotenv.env['OPENAI_API_KEY']!;
```

Usa package `flutter_dotenv`

### Encriptar datos sensibles

```dart
// Usar package 'encrypt'
final encrypted = Encryption.encrypt(note.content);
```

---

## 📊 Analytics

### Agregar analytics

```yaml
dependencies:
  firebase_analytics: ^10.0.0
```

```dart
FirebaseAnalytics.instance.logEvent(name: 'note_created');
```

---

## 🎨 Animaciones

### Animar transiciones

```dart
Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (_, __, ___) => NoteEditPage(),
    transitionsBuilder: (_, animation, __, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  ),
);
```

### Animar cards

```dart
AnimatedSwitcher(
  duration: Duration(milliseconds: 300),
  child: NoteItem(key: ValueKey(note.id), note: note),
)
```

---

## 🌍 Internacionalización

### Agregar soporte multiidioma

```yaml
dependencies:
  intl: ^0.19.0
  easy_localization: ^3.0.0
```

```dart
'hello' : {
  'en': 'Hello',
  'es': 'Hola',
  'fr': 'Bonjour',
}
```

---

## 📲 Notificaciones Push

### Firebase Cloud Messaging

```yaml
dependencies:
  firebase_messaging: ^14.0.0
```

```dart
FirebaseMessaging.onMessage.listen((message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message.notification?.body ?? ''))
  );
});
```

---

## 🎯 Mejores Prácticas

### ✅ Siempre hacer

- Usar const constructores
- Validar inputs
- Manejar errores
- Documentar código
- Usar nombres claros

### ❌ Nunca hacer

- Mutaciones directas de estado
- BuildContext fuera de build
- Async sin manejo de errores
- UI en providers
- Nombres genéricos

---

## 📞 Recursos Útiles

- [Flutter Docs](https://flutter.dev/docs)
- [Riverpod Guide](https://riverpod.dev)
- [SQLite Docs](https://www.sqlite.org/docs.html)
- [OpenAI API](https://platform.openai.com/docs)
- [Material Design](https://m3.material.io)

---

**¡Con estos tips estarás listo para cualquier desafío! 🚀**
