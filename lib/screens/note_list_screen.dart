import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:blogcrud/screens/searchscreen.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helper/note_provider.dart';
import '../navigation/navigation_helper.dart';
import '../utils/constants.dart';
import '../utils/localcrud/constant.dart';
import '../widgets/list_item.dart';
import '../widgets/localcrud/heading_text.dart';
import 'note_edit_screen.dart';

class NoteListScreen extends StatefulWidget {
  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            header(),
            Container(
              height: 550,
              child: FutureBuilder(
                future: Provider.of<NoteProvider>(context, listen: false)
                    .getNotes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Scaffold(
                      body: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Scaffold(
                        body: Consumer<NoteProvider>(
                          child: noNotesUI(context),
                          builder: (context, noteprovider, child) =>
                              noteprovider.items.length <= 0
                                  ? child
                                  : ListView.builder(
                                      padding: EdgeInsets.only(),
                                      physics: BouncingScrollPhysics(),
                                      itemCount: noteprovider.items.length + 1,
                                      itemBuilder: (context, index) {
                                        if (index == 0) {
                                          return Text("");
                                        } else {
                                          final i = index - 1;
                                          final item = noteprovider.items[i];

                                          return ListItem(
                                            item.id,
                                            item.title,
                                            item.content,
                                            item.imagePath,
                                            item.date,
                                          );
                                        }
                                      },
                                    ),
                        ),
                        floatingActionButton: FloatingActionButton(
                          backgroundColor: Colors.green,
                          onPressed: () {
                            goToNoteEditScreen(context);
                          },
                          child: Icon(
                            Icons.add,
                          ),
                        ),
                      );
                    }
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget header() {
    return GestureDetector(
      onTap: _launchUrl,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                const HeadingText(
                    heading: "All Blogs", subHeading: "Find your blogs"),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: InkWell(
              onTap: () {
                NavigationHelper.pushRoute(context, SearchScreen());
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: Colors.grey.withOpacity(0.3)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Icon(Icons.search),
                      SizedBox(
                        width: 13,
                      ),
                      Text(
                        "Search Blog",
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      )
                    ],
                  ),
                ),
              ),
              // child: TextFormField(
              //     onChanged: (value) {
              //       // setState(() {
              //       //   //   filterSeach(value);
              //       // });
              //     },
              //     style: const TextStyle(
              //         letterSpacing: 0,
              //         color: authLabelColor,
              //         fontSize: 14,
              //         fontWeight: FontWeight.w500),
              //     decoration: InputDecoration(
              //         hintText: "Search Blog",
              //         hintStyle: const TextStyle(
              //             letterSpacing: 0.5,
              //             color: authLabelColor,
              //             fontSize: 14,
              //             fontWeight: FontWeight.normal),
              //         prefixIcon: Icon(Icons.search),
              //         filled: true,
              //         fillColor: Colors.grey.shade200,
              //         enabledBorder: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(8),
              //             borderSide:
              //                 const BorderSide(color: Colors.transparent)),
              //         focusedErrorBorder: OutlineInputBorder(
              //             borderSide:
              //                 const BorderSide(color: Colors.transparent),
              //             borderRadius: BorderRadius.circular(8)),
              //         focusedBorder: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(8),
              //             borderSide:
              //                 const BorderSide(color: Colors.transparent)))),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  void _launchUrl() async {
    const url = 'https://www.androidride.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget noNotesUI(BuildContext context) {
    return ListView(
      children: [
        //  header(),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Image.asset(
                'blogging.png',
                fit: BoxFit.cover,
                width: 200.0,
                height: 200.0,
              ),
            ),
            RichText(
              text: TextSpan(style: noNotesStyle, children: [
                TextSpan(text: ' There is no Blog available\n Tap on "'),
                TextSpan(
                    text: '+',
                    style: boldPlus,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        goToNoteEditScreen(context);
                      }),
                TextSpan(text: '" to add new blog')
              ]),
            ),
          ],
        ),
      ],
    );
  }

  void goToNoteEditScreen(BuildContext context) {
    Navigator.of(context).pushNamed(NoteEditScreen.route);
  }
}
