import 'package:flutter/material.dart';
import 'package:blogcrud/screens/blog_view_screen.dart';

import 'package:provider/provider.dart';

import 'helper/blog_provider.dart';
import 'screens/blog_edit_screen.dart';
import 'screens/blog_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: BlogProvider(),
      child: MaterialApp(
        title: "Flutter Blogs",
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => BlogListScreen(),
          blogViewScreen.route: (context) => blogViewScreen(),
          BlogEditScreen.route: (context) => BlogEditScreen(),
        },
      ),
    );
  }
}
