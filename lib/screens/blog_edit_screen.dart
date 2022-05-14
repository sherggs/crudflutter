import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; //Ref: https://pub.dev/packages/fluttertoast

import 'package:image_picker/image_picker.dart'; //image picker from photo library
import 'package:path/path.dart'; //Ref: https://pub.dev/packages/path
 import 'package:path_provider/path_provider.dart'; //Ref: https://pub.dev/packages/provider
 import 'package:provider/provider.dart'; //Ref: https://pub.dev/packages/provider

import '../helper/blog_provider.dart'; //database
import '../models/blog.dart'; //database model
import '../utils/constants.dart'; //styling
import '../utils/localcrud/constant.dart'; //app styling
import '../widgets/delete_popup.dart'; //delet pop up for yes or no validation
import '../widgets/localcrud/customButton.dart'; //custom button styling
import 'blog_view_screen.dart'; //screen/blog_view_screen.dart to read blog data

class BlogEditScreen extends StatefulWidget {
  static const route = '/edit-blog';

  @override
  _BlogEditScreenState createState() {
    return _BlogEditScreenState();
  }
}

class _BlogEditScreenState extends State<BlogEditScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  File? _image;

  final picker = ImagePicker();

  bool firstTime = true;
  Blog? selectedBlog;
  int? id;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    if (firstTime) {
      id = ModalRoute.of(this.context)!.settings.arguments as int?;

      if (id != null) {
        selectedBlog = Provider.of<BlogProvider>(
          this.context,
          listen: false,
        ).getBlog(id!);

        titleController.text = selectedBlog!.title;
        contentController.text = selectedBlog!.content;

        if (selectedBlog?.imagePath != null) {
          _image = File(selectedBlog!.imagePath);
        }
      }
    }
    firstTime = false;
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 80,
        child: Column(
          children: [
            CustomButton(
                padding: 30,
                text: "Save Blog ",
                buttonHeight: 50,
                textSize: 14,
                fontWeight: FontWeight.w500,
                textColor: Colors.white,
                borderColor: Colors.white,
                buttonColor: appColor,
                radius: 6,
                onPress: () {
                  if (titleController.text.isEmpty) {
                    titleController.text = 'Untitled blog';
                  }

                  saveBlog();

                },
                buttonWidth: double.infinity),
          ],
        ),
      ),
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0.7,
        backgroundColor: white,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
          color: black,
        ),
        actions: [

          IconButton(
            icon: const Icon(Icons.share),
            color: Colors.green,
            onPressed: () {
              //  getImage(ImageSource.gallery);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.red,
            onPressed: () {
              if (id != null) {
                _showDialog();
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Stack(children: [
                Container(
                  height: 180,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: _image == null
                            ? const AssetImage(
                          "assets/upload.png",
                        )
                            : FileImage(_image!) as ImageProvider,
                      ),
                      color: const Color(0xffF0F0F0),
                      borderRadius: BorderRadius.circular(6)),
                ),
                Positioned.fill(
                  top: -70,
                  left: 10,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        height: 40,
                        width: 40,
                        child: Center(
                          child: IconButton(
                              icon: const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 19,
                              ),
                              onPressed: () {
                                getImage(ImageSource.gallery);
                              }),
                        ),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),

            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: const Color(0xffF0F0F0),
                    borderRadius: BorderRadius.circular(6)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextFormField(
                    controller: titleController,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                    decoration: const InputDecoration(
                      hintText: "Enter blog title",
                      hintStyle:
                      TextStyle(fontSize: 14, color: Color(0xff828282)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                  height: 130,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: const Color(0xffF0F0F0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      // controller: _dis,
                      controller: contentController,
                      validator: (val) => val!.isEmpty ? "" : null,
                      maxLines: null,
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: "Add a description",
                        hintStyle:
                        TextStyle(fontSize: 14, color: Color(0xff828282)),
                        border: InputBorder.none,
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),

    );
  }

  getImage(ImageSource imageSource) async {
    PickedFile imageFile = await picker.getImage(source: imageSource);

    if (imageFile == null) return;

    File tmpFile = File(imageFile.path);

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = basename(imageFile.path);

    tmpFile = await tmpFile.copy('${appDir.path}/$fileName');

    setState(() {
      _image = tmpFile;
    });
  }

  void saveBlog() {
    String title = titleController.text.trim();
    String content = contentController.text.trim();

    String? imagePath = _image != null ? _image!.path : null;

    if (id != null) {
      Provider.of<BlogProvider>(
        this.context,
        listen: false,
      ).addOrUpdateBlog(id!, title, content, imagePath!, EditMode.UPDATE);
      Navigator.of(this.context).pop();
      Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          textColor: Colors.white,
          msg: "Blog Edited SuccessFully",
          backgroundColor: Colors.green);
      print("new blog added");
    } else {
      int id = DateTime.now().millisecondsSinceEpoch;

      Provider.of<BlogProvider>(this.context, listen: false)
          .addOrUpdateBlog(id, title, content, imagePath!, EditMode.ADD);
      Fluttertoast.showToast(
          textColor: Colors.white,
          msg: "Blog Added SuccessFully",
          backgroundColor: Colors.green);

      Navigator.of(this.context)
          .pushReplacementNamed(blogViewScreen.route, arguments: id);
    }
  }

  void _showDialog() {
    showDialog(
        context: this.context,
        builder: (context) {
          return DeletePopUp(selectedBlog!);
        });
  }
}
