import 'package:flutter/material.dart';
import 'package:journal/models/journal.dart';
import 'package:supabase/supabase.dart';

import 'package:collection/collection.dart';

class JournalService extends ChangeNotifier {
  late final SupabaseClient _client;
  JournalService() {
    _client = SupabaseClient(
      'https://dlrvdojpksbdmvnygpeb.supabase.co',
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoic2VydmljZV9yb2xlIiwiaWF0IjoxNjIyNjg1NTU3LCJleHAiOjE5MzgyNjE1NTd9.WNowEZaOrqqJaI9JOf2XGW-XvfFxjr_Ra2oAW6aC7ks',
    );

    _loadJournals();
  }

  List<Journal> _journals = [];
  List<Journal> get journals => _journals;

  Journal? getJournal(int id) =>
      _journals.firstWhereOrNull((element) => element.id == id);

  Future<void> _loadJournals() async {
    final response =
        await _client.from('journal').select().order('date').execute();

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

  Future<void> removeJournal(int id) async {
    await _client.from('journal').delete().eq('id', id).execute();

    await _loadJournals();
  }
}
