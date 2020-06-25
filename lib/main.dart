import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/strings.dart';
import 'presentation/screens/main/main_page.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
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
