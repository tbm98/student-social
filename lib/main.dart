import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/strings.dart';
import 'models/local/database/database.dart';
import 'presentation/screens/main/main.dart';
import 'presentation/screens/main/main_notifier.dart';
import 'rest_api/rest_client.dart';

void main() {
  runApp(MultiProvider(providers: [
    Provider<MyDatabase>(
      create: (_) => MyDatabase.instance,
      lazy: false,
      // Đặt là lazy false thì nó sẽ được khởi tạo luôn, nếu không thì
      // đến khi dùng nó mới khởi tạo, mà database sẽ tốn 1 khoảng thời
      // gian nhất định để khởi tạo nên sẽ khởi tạo nó luôn từ đầu chánh
      // tới lúc dùng lại phải đợi :D
    ),
    Provider<RestClient>(
      create: (_) => RestClient.create(),
    ),
    ChangeNotifierProvider<MainNotifier>(
      create: (BuildContext ct) =>
          MainNotifier(Provider.of<MyDatabase>(ct, listen: false)),
    )
  ], child: MyApp()));
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
