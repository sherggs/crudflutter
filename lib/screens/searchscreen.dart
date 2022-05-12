import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helper/note_provider.dart';
import '../utils/constants.dart';
import '../utils/localcrud/constant.dart';
import '../widgets/list_item.dart';
import 'note_edit_screen.dart';

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
                future: Provider.of<NoteProvider>(context, listen: false)
                    .getSearchedNotes(keyword.toString()),
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
                        // floatingActionButton: FloatingActionButton(
                        //   backgroundColor: Colors.green,
                        //   onPressed: () {
                        //     goToNoteEditScreen(context);
                        //   },
                        //   child: Icon(
                        //     Icons.add,
                        //   ),
                        // ),
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

  Widget noNotesUI(BuildContext context) {
    return ListView(
      children: [
        //  header(),
        Column(
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(top: 50.0),
            //   child: Image.asset(
            //     'crying_emoji.png',
            //     fit: BoxFit.cover,
            //     width: 200.0,
            //     height: 200.0,
            //   ),
            // ),
            SizedBox(
              height: 200,
            ),
            RichText(
              text: TextSpan(style: noNotesStyle, children: [
                TextSpan(text: ' Search Blogs'),
                // TextSpan(
                //     text: '+',
                //     style: boldPlus,
                //     recognizer: TapGestureRecognizer()
                //       ..onTap = () {
                //         goToNoteEditScreen(context);
                //       }),
                // TextSpan(text: '" to add new blog')
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
