import 'package:flutter/material.dart';

import '../../utils/localcrud/constant.dart';


class SearchTextField extends StatelessWidget {
  const SearchTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
                borderSide: const BorderSide(color: Colors.transparent)),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.transparent))));
  }
}
