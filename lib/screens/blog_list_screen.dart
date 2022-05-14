import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:blogcrud/screens/searchscreen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helper/blog_provider.dart';
import '../navigation/navigation_helper.dart';
import '../utils/constants.dart';
import '../widgets/list_item.dart';
import '../widgets/localcrud/heading_text.dart';
import 'blog_edit_screen.dart';

class blogListScreen extends StatefulWidget {
  @override
  State<blogListScreen> createState() => _blogListScreenState();
}

class _blogListScreenState extends State<blogListScreen> {
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
                future: Provider.of<blogProvider>(context, listen: false)
                    .getblogs(),
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
                        body: Consumer<blogProvider>(
                          child: noblogsUI(context),
                          builder: (context, blogprovider, child) =>
                          blogprovider.items.length <= 0
                              ? child
                              : ListView.builder(
                            padding: EdgeInsets.only(),
                            physics: BouncingScrollPhysics(),
                            itemCount: blogprovider.items.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Text("");
                              } else {
                                final i = index - 1;
                                final item = blogprovider.items[i];

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
                            goToblogEditScreen(context);
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

  Widget noblogsUI(BuildContext context) {
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
                width: 300.0,
                height: 300.0,
              ),
            ),
            RichText(
              text: TextSpan(style: noblogsStyle, children: [
                TextSpan(text: ' There is no Blog available\n Tap on "'),
                TextSpan(
                    text: '+',
                    style: boldPlus,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        goToblogEditScreen(context);
                      }),
                TextSpan(text: '" to add new blog')
              ]),
            ),
          ],
        ),
      ],
    );
  }

  void goToblogEditScreen(BuildContext context) {
    Navigator.of(context).pushNamed(blogEditScreen.route);
  }
}
