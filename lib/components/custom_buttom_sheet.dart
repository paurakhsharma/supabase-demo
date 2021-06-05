import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:journal/components/image_renderer.dart';
import 'package:journal/services/journal_service.dart';
import 'package:provider/provider.dart';

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
  late final List<String> _images;
  final _formKey = GlobalKey<FormState>();
  bool _uploadingImage = false;
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
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.grey[700],
                        padding: const EdgeInsets.all(8),
                        height: 140,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _images.length,
                          itemBuilder: (context, index) {
                            return ImageRenderer(
                              imagePath: _images[index],
                              height: 100,
                            );
                          },
                          separatorBuilder: (context, index) => SizedBox(
                            width: 8,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          onPrimary: Colors.white,
                        ),
                        onPressed:
                            (_uploadingImage || kIsWeb) ? null : _addImage,
                        icon: Icon(Icons.add),
                        label: Text('Add image'),
                      )
                    ],
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
                        onPressed: _onClose,
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

  void _onClose() {
    widget.onClose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final journal = Journal(
        id: widget.journal?.id ?? 1,
        title: _titleController.text,
        description: _descriptionController.text,
        images: _images,
        date: widget.journal?.date ?? DateTime.now(),
      );

      widget.onSave(journal);
      widget.onClose();
    }
  }

  Future<void> _addImage() async {
    setState(() {
      _uploadingImage = true;
    });
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowCompression: true,
      // withData: true,
    );

    if (result == null) return;

    final service = context.read<JournalService>();
    final imagePath = await service.uploadImage(result.files.single);
    if (imagePath != null) {
      _images.add(imagePath);
    }
    setState(() {
      _uploadingImage = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();
    _titleController.text = widget.journal?.title ?? '';

    _descriptionController = TextEditingController();
    _descriptionController.text = widget.journal?.description ?? '';

    _images = widget.journal?.images.toList() ?? [];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
