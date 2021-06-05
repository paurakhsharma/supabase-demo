import 'package:flutter/material.dart';
import 'package:journal/models/journal.dart';

import 'journal_text_field.dart';

class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({
    Key? key,
    required this.onClose,
    required this.onSave,
    this.journal,
  }) : super(key: key);

  final Function onClose;
  final Function(Journal) onSave;

  final Journal? journal;

  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      enableDrag: false,
      onClosing: () {},
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.journal != null ? 'Edit Journal' : 'Add New Journal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 40),
                JournalTextField(
                  controller: _titleController,
                  title: 'Title',
                ),
                SizedBox(height: 20),
                JournalTextField(
                  controller: _descriptionController,
                  title: 'Description',
                  maxLines: 5,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 15,
                  ),
                ),
                SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                        ),
                        onPressed: _onSave,
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => widget.onClose(),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 18,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final journal = Journal(
        id: widget.journal?.id ?? 1,
        title: _titleController.text,
        description: _descriptionController.text,
        images: widget.journal?.images ?? [],
        date: widget.journal?.date ?? DateTime.now(),
      );

      widget.onSave(journal);
      widget.onClose();
    }
  }

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();
    _titleController.text = widget.journal?.title ?? '';

    _descriptionController = TextEditingController();
    _descriptionController.text = widget.journal?.description ?? '';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
