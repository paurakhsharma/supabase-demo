import 'package:flutter/material.dart';
import 'package:journal/components/custom_buttom_sheet.dart';
import 'package:journal/components/journal_tile.dart';

import 'package:provider/provider.dart';

import 'package:journal/services/journal_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _showBottomSheet = false;
  @override
  Widget build(BuildContext context) {
    final service = context.watch<JournalService>();
    final journals = service.journals;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          'Journal',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _showBottomSheet = true;
                  setState(() {});
                });
              },
              icon: Icon(
                Icons.add,
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          children: [
            if (journals.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final journal = journals[index];
                    return JournalTile(journal: journal);
                  },
                  itemCount: journals.length,
                ),
              )
            else
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
          ],
        ),
      ),
      bottomNavigationBar: _showBottomSheet
          ? CustomBottomSheet(
              onClose: () {
                setState(() {
                  _showBottomSheet = false;
                });
              },
              onSave: (journal) {
                service.addJournal(journal);
              },
            )
          : null,
    );
  }
}
