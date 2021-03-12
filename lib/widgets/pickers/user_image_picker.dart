import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imgPickFn);
  final void Function(File imgPicked)imgPickFn;
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;
  void _pickImage()async{
    final PickedFile _pickImageFile=await ImagePicker.platform.pickImage(source: ImageSource.camera,imageQuality: 50,maxWidth: 150);
    setState((){
//      _pickedImage=_pickImageFile;
      _pickedImage = File(_pickImageFile.path);
    });
    widget.imgPickFn(_pickedImage);
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CircleAvatar(backgroundColor: Colors.grey,radius: 40,backgroundImage:_pickedImage != null?FileImage(_pickedImage):null),
      TextButton(onPressed:_pickImage,
          child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [Icon(Icons.image),Text("Pick Image")],)) ,

    ],
    );
  }
}
