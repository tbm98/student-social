import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/strings.dart';
import 'models/local/database/database.dart';
import 'presentation/screens/main/main_page.dart';
import 'presentation/screens/main/main_state_notifier.dart';
import 'rest_api/rest_client.dart';

final myDatabase =
    Provider<MyDatabase>((ProviderReference ref) => MyDatabase.instance);
final restClient =
    Provider<RestClient>((ProviderReference ref) => RestClient.create());
final mainStateNotifier =
    StateNotifierProvider<MainStateNotifier>((ProviderReference ref) {
  return MainStateNotifier(ref.read(myDatabase).value);
});

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<MainStateNotifier>(
      create: (BuildContext ct) =>
          MainStateNotifier(Provider.of<MyDatabase>(ct, listen: false)),
    )
  ], child: ProviderScope(child: MyApp())));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.titleApp,
      theme: ThemeData(primaryColor: Colors.green),
      home: MainScreen(),
    );
  }
}
