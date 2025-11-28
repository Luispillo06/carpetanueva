import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/note.dart';
import '../widgets/note_item.dart';
import '../../../core/services/ai_service.dart';
import 'note_edit_page.dart';
import '../../providers/notes_provider.dart';

/// Página principal que muestra la lista de notas
class NotesListPage extends ConsumerStatefulWidget {
  const NotesListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends ConsumerState<NotesListPage> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(notesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Bloc de Notas'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(notesProvider.notifier).refreshNotes();
            },
            tooltip: 'Recargar notas',
          ),
        ],
      ),
      body: notesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(notesProvider.notifier).refreshNotes();
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
        data: (notes) {
          if (notes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.note_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No hay notas aún'),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _navigateToEditPage(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Crear Primera Nota'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar notas...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              ref.read(notesProvider.notifier).refreshNotes();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (query) {
                    if (query.isEmpty) {
                      ref.read(notesProvider.notifier).refreshNotes();
                    } else {
                      ref.read(notesProvider.notifier).searchNotes(query);
                    }
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return NoteItem(
                      note: note,
                      onTap: () => _navigateToEditPage(context, note),
                      onDelete: () => _showDeleteDialog(context, note),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToEditPage(context),
        tooltip: 'Nueva nota',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToEditPage(BuildContext context, [Note? note]) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteEditPage(initialNote: note)),
    ).then((_) {
      ref.read(notesProvider.notifier).refreshNotes();
    });
  }

  void _showDeleteDialog(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar nota'),
        content: Text('¿Estás seguro de que deseas eliminar "${note.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(notesProvider.notifier).deleteNote(note.id!);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Nota eliminada')));
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
