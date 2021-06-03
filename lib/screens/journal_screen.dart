import 'package:flutter/material.dart';
import 'package:journal/services/journal_service.dart';

import 'package:provider/provider.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    final service = context.watch<JournalService>();
    final journal = service.getJournal(id);
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
              await service.removeJournal(id);
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.delete,
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
      body: Padding(
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
                  Expanded(
                    child: Wrap(
                      children: journal.images
                          .map((e) => Container(
                                height: 200,
                                width: 200,
                                child: Image.network(e),
                              ))
                          .toList(),
                    ),
                  )
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
    );
  }
}
