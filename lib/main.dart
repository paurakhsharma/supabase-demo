import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:journal/models/journal.dart';
import 'package:journal/screens/home_screen.dart';
import 'package:journal/services/journal_service.dart';
import 'package:provider/provider.dart';

import 'screens/journal_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<JournalService>(
          create: (_) => JournalService(),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final routerDelegate = BeamerDelegate(
    locationBuilder: SimpleLocationBuilder(
      routes: {
        // Return either Widgets or BeamPages if more customization is needed
        '/': (context) => HomeScreen(),
        '/journals/:journalId': (context) {
          // Extract the current BeamState which holds route information
          final beamState = context.currentBeamLocation.state;
          // Take the parameter of interest
          final journalId = beamState.pathParameters['journalId']!;
          // Return a Widget or wrap it in a BeamPage for more flexibility
          return BeamPage(
            key: ValueKey('book-$journalId'),
            title: 'A Book #$journalId',
            popToNamed: '/',
            type: BeamPageType.cupertino,
            child: JournalScreen(id: int.parse(journalId)),
          );
        }
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: BeamerParser(),
      debugShowCheckedModeBanner: false,
      title: 'Journal',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      routerDelegate: routerDelegate,
    );
  }
}
