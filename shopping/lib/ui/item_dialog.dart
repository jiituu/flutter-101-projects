import 'package:flutter/material.dart';
import '../util/dbhelper.dart';
import '../models/list_items.dart';

class ItemsDialog {
  final txtName = TextEditingController();
  final txtQuantity = TextEditingController();
  final txtNote = TextEditingController();

  Widget buildDialog(BuildContext context, ListItem item, bool isNew) {
    DbHelper helper = DbHelper();

    if (!isNew) {
      txtName.text = item.name;
      txtQuantity.text = item.quantity;
      txtNote.text = item.note;
    }

    return AlertDialog(
      title: Text((isNew) ? 'New item' : 'Edit item'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: txtName,
              decoration: InputDecoration(
                hintText: 'Name of the item',
              ),
            ),
            TextField(
              controller: txtQuantity,
              decoration: InputDecoration(
                hintText: 'kg/count/lt/etc...',
              ),
            ),
            TextField(
              controller: txtNote,
              decoration: InputDecoration(
                hintText: 'something useful',
              ),
            ),
            ElevatedButton(
              child: Text('Save item'),
              onPressed: () {
                item.name = txtName.text;
                item.quantity = txtQuantity.text;
                item.note = txtNote.text;
                helper.insertItem(item);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
    );
  }
}
