import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:journal/models/journal.dart';

class JournalTile extends StatelessWidget {
  const JournalTile({
    Key? key,
    required this.journal,
  }) : super(key: key);

  final Journal journal;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          journal.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: journal.images.isNotEmpty
            ? Image.network(journal.images.first)
            : null,
        subtitle: Text(
          journal.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          journal.date.toString().substring(2, 10),
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        onTap: () {
          Beamer.of(context).beamToNamed('/journals/${journal.id}');
        },
      ),
    );
  }
}
