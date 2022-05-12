import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';

import '../helper/note_provider.dart';
import '../models/note.dart';

class DeletePopUp extends StatelessWidget {
  final Note selectedNote;

  DeletePopUp(this.selectedNote);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      title: Text('Delete?'),
      content: Text('Do you want to delete the note?'),
      actions: [
        TextButton(
          child: Text('Yes'),
          onPressed: () {
            Provider.of<NoteProvider>(context, listen: false)
                .deleteNote(selectedNote.id);
            Navigator.popUntil(context, ModalRoute.withName('/'));
            Fluttertoast.showToast(
                textColor: Colors.white,
                msg: "Blog Deleted SuccessFully",
                backgroundColor: Colors.red);
          },
        ),
        TextButton(
          child: Text('No'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
