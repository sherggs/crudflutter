import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; //Ref: https://pub.dev/packages/fluttertoast

import 'package:provider/provider.dart'; //Ref: https://pub.dev/packages/provider

import '../helper/blog_provider.dart'; //database provider from helper folder
import '../models/blog.dart'; //blog model

class DeletePopUp extends StatelessWidget {
  final Blog selectedblog;

  DeletePopUp(this.selectedblog);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      title: Text('Delete?'),
      content: Text('Do you want to delete the blog?'),
      actions: [
        TextButton(
          child: Text('Yes'),
          onPressed: () {
            Provider.of<BlogProvider>(context, listen: false)
                .deleteBlog(selectedblog.id);
            Navigator.popUntil(context, ModalRoute.withName('/'));
            Fluttertoast.showToast(
                textColor: Colors.white,
                msg: "Blog Deleted SuccessFully",
                backgroundColor: Colors.red);
          },
        ),
        TextButton(
          child: Text('No'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
