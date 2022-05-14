import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../helper/blog_provider.dart';
import '../models/blog.dart';
import '../utils/constants.dart';
import '../utils/localcrud/constant.dart';
import '../widgets/delete_popup.dart';
import '../widgets/localcrud/customButton.dart';
import 'blog_view_screen.dart';

class blogEditScreen extends StatefulWidget {
  static const route = '/edit-blog';

  @override
  _blogEditScreenState createState() => _blogEditScreenState();
}

class _blogEditScreenState extends State<blogEditScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  File? _image;

  final picker = ImagePicker();

  bool firstTime = true;
  blog? selectedblog;
  int? id;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    if (firstTime) {
      id = ModalRoute.of(this.context)!.settings.arguments as int?;

      if (id != null) {
        selectedblog = Provider.of<blogProvider>(
          this.context,
          listen: false,
        ).getblog(id!);

        titleController.text = selectedblog!.title;
        contentController.text = selectedblog!.content;

        if (selectedblog?.imagePath != null) {
          _image = File(selectedblog!.imagePath);
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
                text: "Save",
                buttonHeight: 50,
                textSize: 14,
                fontWeight: FontWeight.w500,
                textColor: Colors.white,
                borderColor: Colors.white,
                buttonColor: appColor,
                radius: 6,
                onPress: () {
                  if (titleController.text.isEmpty)
                    titleController.text = 'Untitled blog';

                  saveblog();
                  // addProduct();
                },
                buttonWidht: double.infinity),
          ],
        ),
      ),
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0.7,
        backgroundColor: white,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back),
          color: black,
        ),
        actions: [

          IconButton(
            icon: Icon(Icons.share),
            color: black,
            onPressed: () {
              //  getImage(ImageSource.gallery);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            color: black,
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
            SizedBox(
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
                              icon: Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 19,
                              ),
                              onPressed: () {
                                getImage(ImageSource.gallery);
                                //  pickImageFromGallery();
                              }),
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),

            SizedBox(
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
                      //keyboardType: TextInputType.multiline(signed: true),
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

  void saveblog() {
    String title = titleController.text.trim();
    String content = contentController.text.trim();

    String? imagePath = _image != null ? _image!.path : null;

    if (id != null) {
      Provider.of<blogProvider>(
        this.context,
        listen: false,
      ).addOrUpdateblog(id!, title, content, imagePath!, EditMode.UPDATE);
      Navigator.of(this.context).pop();
      Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          textColor: Colors.white,
          msg: "Blog Edited SuccessFully",
          backgroundColor: Colors.yellow);
      print("new blog addded");
    } else {
      int id = DateTime.now().millisecondsSinceEpoch;

      Provider.of<blogProvider>(this.context, listen: false)
          .addOrUpdateblog(id, title, content, imagePath!, EditMode.ADD);
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
          return DeletePopUp(selectedblog!);
        });
  }
}
