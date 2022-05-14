import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helper/blog_provider.dart';
import '../utils/constants.dart';
import '../utils/localcrud/constant.dart';
import '../widgets/list_item.dart';
import 'blog_edit_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? keyword;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back)),
                  Container(
                    height: 50,
                    width: 280,
                    child: TextFormField(
                        onChanged: (value) {
                          keyword = value;
                          setState(() {});
                        },
                        style: const TextStyle(
                            letterSpacing: 0,
                            color: authLabelColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                            hintText: "Search Blog",
                            hintStyle: const TextStyle(
                                letterSpacing: 0.5,
                                color: authLabelColor,
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                            prefixIcon: Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Colors.transparent)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(8)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                    color: Colors.transparent)))),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 600,
              child: FutureBuilder(
                future: Provider.of<BlogProvider>(context, listen: false)
                    .getSearchedBlogs(keyword.toString()),
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
                          child: noblogsUI(context),
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

  Widget noblogsUI(BuildContext context) {
    return ListView(
      children: [
        //  header(),
        Column(
          children: [

            SizedBox(
              height: 200,
            ),
            RichText(
              text: TextSpan(style: noblogsStyle, children: const [
                TextSpan(text: ' Search Blogs'),
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
