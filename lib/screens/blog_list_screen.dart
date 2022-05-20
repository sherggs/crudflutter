// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:blogcrud/screens/searchscreen.dart';  //to search for items with title name
import 'package:provider/provider.dart'; //Ref: https://pub.dev/packages/provider
import '../helper/blog_provider.dart'; //provides database
import '../navigation/navigation_helper.dart';
import '../utils/constants.dart'; //styling
import '../widgets/list_item.dart'; //styling for listing each items on the page
import '../widgets/localcrud/heading_text.dart'; //styling for heading and sub heading
import 'blog_edit_screen.dart'; //  page displayed when the + is clicked

class BlogListScreen extends StatefulWidget {
  @override
  State<BlogListScreen> createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
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
            SizedBox(
              height: 700,
              width: 500,
              child: FutureBuilder(
                future: Provider.of<BlogProvider>(context, listen: false)
                    .getBlogs(),
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
                        body: Consumer<BlogProvider>(
                          child: noBlogsUI(context),
                          builder: (context, Blogprovider, child) =>
                          Blogprovider.items.length <= 0
                              ? child
                              : ListView.builder(
                            padding: EdgeInsets.only(),
                            physics: BouncingScrollPhysics(),
                            itemCount: Blogprovider.items.length + 1,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Text("");
                              } else {
                                final i = index - 1;
                                final item = Blogprovider.items[i];

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
                    heading: "All Blogs", subHeading: "Add or Find your blogs"),
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
                        "Search for your Blog title ",
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


  Widget noBlogsUI(BuildContext context) {
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
                width: 250.0,
                height: 250.0,
              ),
            ),
            RichText(
              text: TextSpan(style: noblogsStyle, children: [
                TextSpan(text: ' There is no accessible Blog\n Click the button to add new')
              ]),
            ),
          ],
        ),
      ],
    );
  }

  void goToblogEditScreen(BuildContext context) {
    Navigator.of(context).pushNamed(BlogEditScreen.route);
  }
}
