import 'package:flutter/material.dart';

import 'custom_text.dart';
import 'event_detail_card.dart';

class EventCard extends StatefulWidget {
  final String title;
  final String descriptiom;
  final String image;

  EventCard(this.title, this.descriptiom, this.image);

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  // EventCard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 120,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 1, color: Color(0xff707070).withOpacity(0.2)))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 10,
          ),
          Container(
            width: 110,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
            ),
            //   child: Image.asset("assets/images/testImage.png"),
            child: Image.asset(widget.image.toString()),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                  text: widget.title.toString(),
                  textSize: 14,
                  fontWeight: FontWeight.w600,
                  textColor: Colors.black),
              SizedBox(
                height: 5,
              ),
              Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: CustomText(
                      text: widget.descriptiom.toString(),
                      textSize: 12,
                      fontWeight: FontWeight.normal,
                      textColor: Colors.black54)),
              SizedBox(
                height: 5,
              ),
              EventDetailCard(
                text: 'Jan 10, 2022',
                icon: 'calender.png',
              ),
            ],
          )
        ],
      ),
    );
  }
}
