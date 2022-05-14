import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helper/note_provider.dart';
import '../models/note.dart';
import '../utils/constants.dart';
import '../utils/localcrud/constant.dart';
import '../widgets/delete_popup.dart';
import '../widgets/localcrud/customButton.dart';
import '../widgets/localcrud/custom_text.dart';
import '../widgets/localcrud/event_detail_card.dart';
import 'note_edit_screen.dart';

class NoteViewScreen extends StatefulWidget {
  static const route = '/note-view';

  @override
  _NoteViewScreenState createState() => _NoteViewScreenState();
}

class _NoteViewScreenState extends State<NoteViewScreen> {
  Note? selectedNote;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    final id = ModalRoute.of(context)!.settings.arguments;

    final provider = Provider.of<NoteProvider>(context);

    ///need to uncomment
    if (provider.getNote(id as int) != null) {
      selectedNote = provider.getNote(id);
    }
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
                text: "Edit Blog",
                buttonHeight: 50,
                textSize: 14,
                fontWeight: FontWeight.w500,
                textColor: Colors.white,
                borderColor: Colors.white,
                buttonColor: appColor,
                radius: 6,
                onPress: () {
                  Navigator.pushNamed(context, NoteEditScreen.route,
                      arguments: selectedNote!.id);
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
          icon: Icon(
            Icons.arrow_back,
            color: black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
              color: black,
            ),
            onPressed: ()async {
              // FlutterShare.share(
              //         title: selectedNote!.title.toString(),
              //         text: selectedNote!.content.toString(),
              //         linkUrl: selectedNote!.imagePath.toString(),
              //         chooserTitle: selectedNote!.date.toString())
              //     .then((value) {
              //   Fluttertoast.showToast(
              //       msg: "Blog Shared SuccessFully",
              //       toastLength: Toast.LENGTH_SHORT,
              //       gravity: ToastGravity.BOTTOM,
              //       timeInSecForIosWeb: 1,
              //       backgroundColor: Colors.red,
              //       textColor: Colors.white,
              //       fontSize: 16.0);
              // });
              await _launchURL("", selectedNote!.title, selectedNote!.content);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: black,
            ),
            onPressed: () => _showDialog(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                selectedNote!.title,
                style: viewTitleStyle,
              ),
            ),
            if (selectedNote!.imagePath != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  height: 180,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(


                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(selectedNote!.imagePath)
                        as ImageProvider,
                      ),
                      color: const Color(0xffF0F0F0),
                      borderRadius: BorderRadius.circular(9)),
                ),
              ),
            SizedBox(
              height: 15,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 15,
                    color: Colors.black.withOpacity(0.4),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    selectedNote!.date.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: itemDateStyle,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: CustomText(
                  text: "Information",
                  textSize: 14,
                  fontWeight: FontWeight.w600,
                  textColor: Colors.black),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                selectedNote!.content,
                style: viewContentStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showDialog() {
    showDialog(
        context: this.context,
        builder: (context) {
          return DeletePopUp(selectedNote!);
        });
  }
  _launchURL(String toMailId, String subject, String body) async {
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}