import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagepickfn;
  UserImagePicker(this.imagepickfn);
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedimage;
  void imagepick() async {
    final pickedimage = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxHeight: 150);
    setState(() {
      _pickedimage = pickedimage;
    });
    widget.imagepickfn(pickedimage);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage:
              _pickedimage != null ? FileImage(_pickedimage) : null,
        ),
        FlatButton.icon(
            textColor: Theme.of(context).primaryColor,
            onPressed: imagepick,
            icon: Icon(Icons.image),
            label: Text('Add image')),
      ],
    );
  }
}
