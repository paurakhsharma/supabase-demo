import 'package:flutter/material.dart';
import 'package:journal/components/custom_buttom_sheet.dart';
import 'package:journal/services/journal_service.dart';

import 'package:provider/provider.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  bool _showBottomSheet = false;
  @override
  Widget build(BuildContext context) {
    final service = context.watch<JournalService>();
    final journal = service.getJournal(widget.id);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          journal?.title ?? '',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await service.removeJournal(widget.id);
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.delete,
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: journal != null
              ? Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(42),
                        child: Text(
                          journal.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Wrap(
                      runSpacing: 20,
                      spacing: 20,
                      children: journal.images
                          .map((e) => Container(
                                height: journal.images.length == 1 ? 250 : 150,
                                width: journal.images.length == 1 ? 250 : 150,
                                child: Image.network(
                                  e,
                                  fit: BoxFit.cover,
                                ),
                              ))
                          .toList(),
                    )
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
      floatingActionButton: !_showBottomSheet
          ? FloatingActionButton(
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _showBottomSheet = true;
                });
              },
            )
          : null,
      bottomSheet: _showBottomSheet
          ? CustomBottomSheet(
              journal: journal,
              onClose: () {
                setState(() {
                  _showBottomSheet = false;
                });
              },
              onSave: (updatedJournal) {
                service.updateJournal(updatedJournal);
              },
            )
          : null,
    );
  }
}
