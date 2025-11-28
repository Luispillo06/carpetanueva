import 'package:flutter/material.dart';
import '../../../core/models/note.dart';

/// Formulario para crear o editar una nota
class NoteForm extends StatefulWidget {
  final Note? initialNote;
  final Function(String title, String content) onSubmit;
  final bool isLoading;

  const NoteForm({
    Key? key,
    this.initialNote,
    required this.onSubmit,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final _formKey = GlobalKey<FormState>();

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

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(_titleController.text, _contentController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Título',
              hintText: 'Ingresa el título de la nota',
              prefixIcon: const Icon(Icons.title),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El título no puede estar vacío';
              }
              if (value.length < 3) {
                return 'El título debe tener al menos 3 caracteres';
              }
              return null;
            },
            enabled: !widget.isLoading,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _contentController,
            decoration: InputDecoration(
              labelText: 'Contenido',
              hintText: 'Escribe el contenido de la nota',
              prefixIcon: const Icon(Icons.description),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            maxLines: 8,
            minLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El contenido no puede estar vacío';
              }
              if (value.length < 5) {
                return 'El contenido debe tener al menos 5 caracteres';
              }
              return null;
            },
            enabled: !widget.isLoading,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: widget.isLoading ? null : _handleSubmit,
            icon: widget.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            label: Text(
              widget.initialNote == null ? 'Crear Nota' : 'Actualizar Nota',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
