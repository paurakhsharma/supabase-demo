import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:journal/env_config.dart';
import 'package:journal/models/journal.dart';
import 'package:supabase/supabase.dart';

import 'package:collection/collection.dart';

class JournalService extends ChangeNotifier {
  late final SupabaseClient _client;
  JournalService() {
    _client = SupabaseClient(
      EnvironmentConfig.SupabaseURL,
      EnvironmentConfig.SupabaseToken,
    );

    _loadJournals();
  }

  List<Journal> _journals = [];
  List<Journal> get journals => _journals;

  Journal? getJournal(int id) =>
      _journals.firstWhereOrNull((element) => element.id == id);

  Future<void> _loadJournals() async {
    final response = await _client.from('journal').select().execute();

    _journals = [];

    response.data.forEach((e) => _journals.add(Journal.fromMap(e)));

    notifyListeners();
  }

  Future<void> addJournal(Journal journal) async {
    final journalMap = journal.toMap();
    journalMap.remove('id');
    journalMap.remove('date');
    await _client.from('journal').insert(journalMap).execute();

    await _loadJournals();
  }

  Future<void> updateJournal(Journal journal) async {
    final journalMap = journal.toMap();
    final id = journalMap.remove('id');

    await _client.from('journal').update(journalMap).eq('id', id).execute();

    await _loadJournals();
  }

  Future<void> removeJournal(int id) async {
    await _client.from('journal').delete().eq('id', id).execute();

    await _loadJournals();
  }

  Future<dynamic> downloadImage(String imagePath) {
    final name = imagePath.replaceFirst('journalImages/', '');
    print(name);
    return _client.storage.from('journalImages').download(name);
  }

  Future<String?> uploadImage(PlatformFile file) async {
    final response = await _client.storage.from('journalImages').upload(
          '${DateTime.now().toString()}_${file.name}',
          File(file.path!),
        );

    print(response.error?.error);
    print(response.error?.message);

    if (response.data == null) return null;
    await _client.storage.from('journalImages').download(response.data!);
    return response.data;
  }
}
