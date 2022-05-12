import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../helper/note_provider.dart';
import '../models/note.dart';
import '../utils/constants.dart';
import '../utils/localcrud/constant.dart';
import '../widgets/delete_popup.dart';
import '../widgets/localcrud/customButton.dart';
import 'note_list_screen.dart';
import 'note_view_screen.dart';

class NoteEditScreen extends StatefulWidget {
  static const route = '/edit-note';

  @override
  _NoteEditScreenState createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  File? _image;

  final picker = ImagePicker();

  bool firstTime = true;
  Note? selectedNote;
  int? id;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    if (firstTime) {
      id = ModalRoute.of(this.context)!.settings.arguments as int?;

      if (id != null) {
        selectedNote = Provider.of<NoteProvider>(
          this.context,
          listen: false,
        ).getNote(id!);

        titleController.text = selectedNote!.title;
        contentController.text = selectedNote!.content;

        if (selectedNote?.imagePath != null) {
          _image = File(selectedNote!.imagePath);
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
                    titleController.text = 'Untitled Note';

                  saveNote(context);
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
          // IconButton(
          //   icon: Icon(Icons.photo_camera),
          //   color: black,
          //   onPressed: () {
          //     getImage(ImageSource.camera);
          //   },
          // ),
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
            // Padding(
            //   padding: EdgeInsets.only(
            //       left: 10.0, right: 5.0, top: 10.0, bottom: 5.0),
            //   child: TextField(
            //     controller: titleController,
            //     maxLines: null,
            //     textCapitalization: TextCapitalization.sentences,
            //     style: createTitle,
            //     decoration: InputDecoration(
            //         hintText: 'Enter Note Title', border: InputBorder.none),
            //   ),
            // ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Stack(children: [
                _image == null ?Container(
                  height: 180,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: const Color(0xffF0F0F0),
                      borderRadius: BorderRadius.circular(6)
                  ),
                  child: Image.asset("assets/arrowup.png"),
                ):
                Container(
                  height: 180,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image:
                            FileImage(_image!) as ImageProvider,
                      ),
                      color: const Color(0xffF0F0F0),
                      borderRadius: BorderRadius.circular(6)),
                  // child: Icon(
                  //   Icons.upload_rounded,
                  //   size: 32,
                  // ),
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
                                //pickImageFromGallery();
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
            // if (_image != null)
            //   Container(
            //     padding: EdgeInsets.all(10.0),
            //     width: MediaQuery.of(context).size.width,
            //     height: 250.0,
            //     child: Stack(
            //       children: [
            //         Container(
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(20.0),
            //             image: DecorationImage(
            //               image: FileImage(_image!),
            //               fit: BoxFit.cover,
            //             ),
            //           ),
            //         ),
            //         Align(
            //           alignment: Alignment.bottomRight,
            //           child: Padding(
            //             padding: EdgeInsets.all(12.0),
            //             child: Container(
            //               height: 30.0,
            //               width: 30.0,
            //               decoration: BoxDecoration(
            //                 shape: BoxShape.circle,
            //                 color: Colors.white,
            //               ),
            //               child: InkWell(
            //                 onTap: () {
            //                   setState(() {
            //                     _image = null;
            //                   });
            //                 },
            //                 child: Icon(
            //                   Icons.delete,
            //                   size: 16.0,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
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
                      keyboardType: TextInputType.multiline,
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     if (titleController.text.isEmpty)
      //       titleController.text = 'Untitled Note';
      //
      //     saveNote();
      //   },
      //   child: Icon(Icons.save),
      // ),
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

  void saveNote(BuildContext context) {
    String title = titleController.text.trim();
    String content = contentController.text.trim();

    String? imagePath = _image != null ? _image!.path : null;

    if (id != null) {
      Provider.of<NoteProvider>(
        this.context,
        listen: false,
      ).addOrUpdateNote(id!, title, content, imagePath!, EditMode.UPDATE);
      Navigator.of(this.context).pop();
      Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          textColor: Colors.white,
          msg: "Blog Edited SuccessFully",
          backgroundColor: Colors.green);
      print("blog addded");
    } else {
      int id = DateTime.now().millisecondsSinceEpoch;

      Provider.of<NoteProvider>(this.context, listen: false)
          .addOrUpdateNote(id, title, content, imagePath!, EditMode.ADD);
      Fluttertoast.showToast(
          textColor: Colors.white,
          msg: "Blog Added SuccessFully",
          backgroundColor: Colors.green);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NoteListScreen()));
    }
  }

  void _showDialog() {
    showDialog(
        context: this.context,
        builder: (context) {
          return DeletePopUp(selectedNote!);
        });
  }
}
