import 'package:flutter/material.dart';
import '../models/blog.dart';
import '../utils/constants.dart';
import 'database_helper.dart';

class blogProvider with ChangeNotifier {
  List<dynamic> _items = [];

  List<dynamic> get items {
    return [..._items];
  }

  blog getblog(int id) {
    return _items.firstWhere((blog) => blog.id == id, orElse: () => null);
  }

  Future deleteblog(int id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
    return DatabaseHelper.delete(id);
  }

  Future addOrUpdateblog(int id, String title, String content, String imagePath,
      EditMode editMode) async {
    final blog = blog(id, title, content, imagePath);

    if (EditMode.ADD == editMode) {
      _items.insert(0, blog);
    } else {
      _items[_items.indexWhere((blog) => blog.id == id)] = blog;
    }

    notifyListeners();

    DatabaseHelper.insert({
      'id': blog.id,
      'title': blog.title,
      'content': blog.content,
      'imagePath': blog.imagePath,
    });
  }

  Future getblogs() async {
    final blogsList = await DatabaseHelper.getblogsFromDB();

    _items = blogsList
        .map(
          (item) => blog(item['id'] as int, item['title'] as String,
              item['content'] as String, item['imagePath'] as String),
        )
        .toList();

    notifyListeners();
  }

  Future getSearchedblogs(String keyword) async {
    final searchblogsList = await DatabaseHelper.getSearchblogsFromDB(keyword);

    _items = searchblogsList
        .map(
          (item) => blog(item['id'] as int, item['title'] as String,
              item['content'] as String, item['imagePath'] as String),
        )
        .toList();

    notifyListeners();
  }
}
