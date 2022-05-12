import 'dart:io';

import 'package:flutter/material.dart';

import '../screens/note_view_screen.dart';
import '../utils/constants.dart';
import 'localcrud/custom_text.dart';
import 'localcrud/event_detail_card.dart';

class ListItem extends StatelessWidget {
  final int id;
  final String title;
  final String content;
  final String imagePath;
  final String date;

  ListItem(this.id, this.title, this.content, this.imagePath, this.date);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 90.0,
          margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, NoteViewScreen.route, arguments: id);
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                //   color: white,
                //   boxShadow: shadow,
                borderRadius: BorderRadius.circular(15.0),
                // border: Border.all(
                //   color: grey,
                //   width: 1.0,
                // ),
              ),
              child: Row(
                children: [
                  if (imagePath != null)
                    Row(
                      children: [
                        SizedBox(
                          width: 12.0,
                        ),
                        Container(
                          width: 80.0,
                          height: 80.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            image: DecorationImage(
                              image: FileImage(
                                File(imagePath),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      ],
                    ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                              text: title,
                              textSize: 14,
                              fontWeight: FontWeight.w600,
                              textColor: Colors.black),
                          SizedBox(
                            height: 8.0,
                          ),
                          Expanded(
                            child: Text(
                              content,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: itemContentStyle,
                            ),
                          ),
                          Row(
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
                                date,
                                overflow: TextOverflow.ellipsis,
                                style: itemDateStyle,
                              ),
                            ],
                          ),
                          // EventDetailCard(
                          //   text: date,
                          //   icon: 'calender.png',
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Divider(
            color: Colors.black.withOpacity(0.2),
          ),
        )
      ],
    );
  }
}
