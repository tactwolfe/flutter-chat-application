import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImagePicker extends StatefulWidget {

  final void Function(File pickedImage ) imagePickFunction;

  UserImagePicker(this.imagePickFunction);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {

  File _pickedImage;

  void _pickImage() async{
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.camera ,imageQuality: 50,maxWidth: 150); //here we have used imagequality arguments and maxwidth for the image so that we can store the image in small dimensiona and medium quality since we are goin to show it as a little avatarimange in our chats and thus this saves space in out database and make ading and fetching the image faster
    final pickedImageFile = File(pickedImage.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });

    widget.imagePickFunction(pickedImageFile); //this function will take the picked image file and retuen it to auth form which then will retun it to auth screen from where this image will get loaded into the database

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //user image
        CircleAvatar(
          backgroundImage: _pickedImage != null ? FileImage(_pickedImage) : null,
          backgroundColor: Colors.blueGrey,
          radius: 50,
        ),

        //button that gonna help us to pick an image
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text("Add Image"),
        ),
      ],
    );
  }
}
