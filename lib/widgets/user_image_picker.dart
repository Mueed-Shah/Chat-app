import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.imagePicker});
  final void Function(File pickedImage) imagePicker;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage ;
  void pickImage() async{
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if(image == null){
      return;
    }
    setState(() {
      _pickedImage = File(image.path);
    });
    widget.imagePicker(_pickedImage!);

  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
        radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage:
              _pickedImage != null ? FileImage(_pickedImage!): null,

        ),


        TextButton.icon(onPressed: pickImage,
            icon: const Icon(Icons.image),
            label: Text('Add image',style: TextStyle(color: Theme.of(context).colorScheme.primary),))
      ],
    );
  }
}
