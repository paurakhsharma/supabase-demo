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
    final response = await _client
        .from('journal')
        .select()
        .order('date', ascending: false)
        .execute();

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

  Future<String?> uploadImage(PlatformFile file) async {
    final bucketName = 'journalImages';
    final fileName = '${DateTime.now().toString()}_${file.name}';
    final response = await _client.storage.from(bucketName).upload(
          fileName,
          File(file.path!),
        );

    if (response.data == null) return null;
    return _client.storage
        .from('journalImages')
        .getPublicUrl(response.data!.replaceFirst('$bucketName/', ''))
        .data;
  }
}
