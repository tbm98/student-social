import 'package:flutter/material.dart';
import 'support/resources/strings.dart';
import 'viewmodels/main_viewmodel.dart';
import 'views/views_main/main.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainViewModel>(
      create: (_) => MainViewModel(),
      child: MaterialApp(
          title: Strings.titleApp,
          theme: ThemeData(
            primaryColor: Colors.green,
          ),
          home: MainPage()),
    );
  }
}
