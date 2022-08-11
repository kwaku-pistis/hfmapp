import 'dart:async';
import 'dart:io';
import 'package:HFM/screens/upload_photo_screen.dart';
import 'package:HFM/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  late File imageFile;

  Future<File> _pickImage(String action) async {
    XFile? selectedImage;

    action == 'Gallery'
        ? selectedImage =
            await ImagePicker().pickImage(source: ImageSource.gallery)
        : selectedImage =
            await ImagePicker().pickImage(source: ImageSource.camera);

    return selectedImage as File;
  }

  _showImageDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: const Text('Choose from Gallery'),
                onPressed: () {
                  //Navigator.pop(context);
                  _pickImage('Gallery').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const UploadPhotoScreen(
                                //imageFile: imageFile,
                                ))));
                    //Navigator.of(context).pop();
                  });
                },
              ),
              SimpleDialogOption(
                child: const Text('Take Photo'),
                onPressed: () {
                  //Navigator.of(context).pop();
                  _pickImage('Camera').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const UploadPhotoScreen(
                                //imageFile: imageFile,
                                ))));
                  });
                },
              ),
              SimpleDialogOption(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorTheme.primaryColor,
        title: const Text(
          'Add Photo',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Center(
          child: ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            colorTheme.primaryColor,
          ),
          shape: MaterialStateProperty.all(const StadiumBorder()),
        ),
        label: const Text(
          'Upload Image',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(
          Icons.cloud_upload,
          color: Colors.white,
        ),
        onPressed: _showImageDialog,
      )),
    );
  }
}
