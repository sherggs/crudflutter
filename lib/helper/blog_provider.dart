import 'package:flutter/material.dart';
import '../models/blog.dart'; //blog model
import '../utils/constants.dart'; //styling
import 'database_helper.dart'; //databse helper

class BlogProvider with ChangeNotifier {
  List<dynamic> _items = [];

  List<dynamic> get items {
    return [..._items];
  }

  Blog getBlog(int id) {
    return _items.firstWhere((blog) => blog.id == id, orElse: () => null);
  }

  Future deleteBlog(int id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
    return DatabaseHelper.delete(id);
  }

  Future addOrUpdateBlog(int id, String title, String content, String imagePath,
      EditMode editMode) async {
    final blog = Blog(id, title, content, imagePath);

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

  Future getBlogs() async {
    final blogsList = await DatabaseHelper.getBlogsFromDB();

    _items = blogsList.map((item) => Blog(item['id'] as int, item['title'] as String,
              item['content'] as String, item['imagePath'] as String),
        )
        .toList();

    notifyListeners();
  }

  Future getSearchedBlogs(String keyword) async {
    final searchBlogsList = await DatabaseHelper.getSearchBlogsFromDB(keyword);

    _items = searchBlogsList
        .map(
          (item) => Blog(item['id'] as int, item['title'] as String,
              item['content'] as String, item['imagePath'] as String),
        )
        .toList();

    notifyListeners();
  }

}