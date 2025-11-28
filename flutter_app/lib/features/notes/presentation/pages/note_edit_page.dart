import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/note.dart';
import '../../../core/services/ai_service.dart';
import '../widgets/note_form.dart';
import '../../providers/notes_provider.dart';

/// Página para crear o editar una nota
class NoteEditPage extends ConsumerStatefulWidget {
  final Note? initialNote;

  const NoteEditPage({Key? key, this.initialNote}) : super(key: key);

  @override
  ConsumerState<NoteEditPage> createState() => _NoteEditPageState();
}

class _NoteEditPageState extends ConsumerState<NoteEditPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isLoading = false;
  bool _isAILoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.initialNote?.title ?? '',
    );
    _contentController = TextEditingController(
      text: widget.initialNote?.content ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit(String title, String content) async {
    setState(() => _isLoading = true);
    try {
      if (widget.initialNote == null) {
        // Crear nueva nota
        await ref.read(notesProvider.notifier).createNote(title, content);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nota creada exitosamente')),
          );
          Navigator.pop(context);
        }
      } else {
        // Actualizar nota existente
        final updatedNote = widget.initialNote!.copyWith(
          title: title,
          content: content,
          updatedAt: DateTime.now(),
        );
        await ref.read(notesProvider.notifier).updateNote(updatedNote);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nota actualizada exitosamente')),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _summarizeNote() async {
    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, escribe algo para resumir')),
      );
      return;
    }

    setState(() => _isAILoading = true);
    try {
      final summary = await AIService.summarizeText(_contentController.text);
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Resumen de IA'),
            content: Text(summary),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
              TextButton(
                onPressed: () {
                  _contentController.text = summary;
                  Navigator.pop(context);
                },
                child: const Text('Usar resumen'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al resumir: $e')));
      }
    } finally {
      setState(() => _isAILoading = false);
    }
  }

  Future<void> _improveText() async {
    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, escribe algo para mejorar')),
      );
      return;
    }

    setState(() => _isAILoading = true);
    try {
      final improved = await AIService.improveText(_contentController.text);
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Texto mejorado por IA'),
            content: Text(improved),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
              TextButton(
                onPressed: () {
                  _contentController.text = improved;
                  Navigator.pop(context);
                },
                child: const Text('Usar mejora'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al mejorar: $e')));
      }
    } finally {
      setState(() => _isAILoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialNote == null ? 'Nueva Nota' : 'Editar Nota'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NoteForm(
              initialNote: widget.initialNote,
              onSubmit: _handleSubmit,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 24),
            if (_contentController.text.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'Funciones de IA',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _isAILoading ? null : _summarizeNote,
                    icon: _isAILoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.auto_awesome),
                    label: const Text('Resumir con IA'),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _isAILoading ? null : _improveText,
                    icon: _isAILoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.spellcheck),
                    label: const Text('Mejorar Redacción'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
