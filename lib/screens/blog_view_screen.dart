
import 'package:flutter/material.dart';

import 'package:provider/provider.dart'; //Ref: https://pub.dev/packages/provider
import 'package:url_launcher/url_launcher.dart'; //for the share icon to redirect to the mail

import '../helper/blog_provider.dart'; //database Provider
import '../models/blog.dart'; //database model
import '../utils/constants.dart'; //constants "google fonts styles"
import '../utils/localcrud/constant.dart';
import '../widgets/delete_popup.dart'; //the screen that pops up for the yes or no validation
import '../widgets/localcrud/customButton.dart'; //custom button styling
import '../widgets/localcrud/custom_text.dart'; //custom text styling
import 'blog_edit_screen.dart'; //create and update screen

class blogViewScreen extends StatefulWidget {
  static const route = '/blog-view';

  @override
  _blogViewScreenState createState() => _blogViewScreenState();
}

class _blogViewScreenState extends State<blogViewScreen> {
  Blog? selectedBlog;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    final id = ModalRoute.of(context)!.settings.arguments;

    final provider = Provider.of<BlogProvider>(context);

    ///need to uncomment
    if (provider.getBlog(id as int) != null) {
      selectedBlog = provider.getBlog(id);
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
                  Navigator.pushNamed(context, BlogEditScreen.route,
                      arguments: selectedBlog!.id);
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
              color: Colors.green,
            ),
            onPressed: ()async {
              await _launchURL("", selectedBlog!.title, selectedBlog!.content);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
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
                selectedBlog!.title,
                style: viewTitleStyle,
              ),
            ),
            if (selectedBlog!.imagePath != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  height: 180,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(


                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(selectedBlog!.imagePath)
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
                    selectedBlog!.date.toString(),
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
                selectedBlog!.content,
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
          return DeletePopUp(selectedBlog!);
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
