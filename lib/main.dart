import 'package:flutter/cupertino.dart';

import 'package:ibmi/pages/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'IBMI',
      routes: {'/': (BuildContext _context) => MainPage()},
      initialRoute: '/',
    );
  }
}
