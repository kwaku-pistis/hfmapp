import 'dart:async';
import 'dart:io';
import 'package:HFM/resources/repository.dart';
import 'package:HFM/screens/home.dart';
import 'package:HFM/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'dart:math';

class UploadPhotoScreen extends StatefulWidget {
  const UploadPhotoScreen({Key? key}) : super(key: key);

  // File imageFile;
  // UploadPhotoScreen({this.imageFile});

  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  late File? imageFile;
  final _locationController = TextEditingController();
  final _captionController = TextEditingController();
  final _repository = Repository();
  late String caption, location;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _locationController.dispose();
    _captionController.dispose();
  }

  bool _visibility = true;

  void _changeVisibility(bool visibility) {
    setState(() {
      _visibility = visibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Post',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: colorTheme.primaryColor,
        elevation: 1.0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 0.0),
            child: GestureDetector(
              child: Icon(
                Icons.send,
                color: colorTheme.primaryColorDark,
              ),
              onTap: () {
                // To show the CircularProgressIndicator
                _changeVisibility(false);

                _repository.getCurrentUser().then((currentUser) {
                  if (currentUser != null) {
                    compressImage();
                    _repository.retrieveUserDetails(currentUser).then((user) {
                      _repository.uploadImageToStorage(imageFile!).then((url) {
                        _repository
                            .addPostToDb(user, url, _captionController.text,
                                _locationController.text)
                            .then((value) {
                          print("Post added to db");
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => Home(
                                        user: null,
                                      ))),
                              ModalRoute.withName(''));
                        }).catchError((e) =>
                                print("Error adding current post to db : $e"));
                      }).catchError((e) {
                        print("Error uploading image to storage : $e");
                      });
                    });
                  } else if (imageFile == null) {
                    _repository.retrieveUserDetails(currentUser).then((user) {
                      _repository
                          .addPostToDb(user, '', _captionController.text,
                              _locationController.text)
                          .then((value) {
                        print("Post added to db");
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => Home(
                                      user: null,
                                    ))),
                            ModalRoute.withName(''));
                      }).catchError((e) =>
                              print("Error adding current post to db : $e"));
                    });
                  } else {
                    print("Current User is null");
                  }
                });
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          // height: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                      child: TextField(
                        controller: _captionController,
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          hintText: 'Write a message...',
                          contentPadding: EdgeInsets.only(bottom: 20, top: 16),
                        ),
                        onChanged: ((value) {
                          setState(() {
                            caption = value;
                          });
                        }),
                        maxLines: null,
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _locationController,
                  textCapitalization: TextCapitalization.words,
                  onChanged: ((value) {
                    setState(() {
                      location = value;
                    });
                  }),
                  decoration: const InputDecoration(
                    hintText: 'Add location',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: FutureBuilder(
                    future: locateUser(),
                    builder: ((context, AsyncSnapshot<GeoData?> snapshot) {
                      //  if (snapshot.hasData) {
                      if (snapshot.hasData) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              child: Chip(
                                label: Text(snapshot.data!.city),
                              ),
                              onTap: () {
                                setState(() {
                                  _locationController.text =
                                      snapshot.data!.city;
                                });
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: GestureDetector(
                                child: Chip(
                                  // label: Text(
                                  //     snapshot.data.first.subAdminArea == null
                                  //         ? 'No sub Area found'
                                  //         : snapshot.data.first.subAdminArea
                                  //         // +
                                  //         //             ", " +
                                  //         //             snapshot.data.first
                                  //         //                 .subLocality ==
                                  //         //         null
                                  //         //     ? 'No sub-locality found'
                                  //         //     : snapshot.data.first.subLocality
                                  //         ),
                                  label: RichText(
                                    text: TextSpan(
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 12),
                                        children: [
                                          TextSpan(text: snapshot.data!.state),
                                          const TextSpan(text: ', '),
                                          TextSpan(text: snapshot.data!.state),
                                        ]),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    _locationController.text =
                                        snapshot.data!.city;
                                  });
                                },
                              ),
                            ),
                          ],
                        );
                      } else {
                        print("Connection State : ${snapshot.connectionState}");
                        return const CircularProgressIndicator();
                      }
                    })),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: imageFile == null
                              ? const AssetImage('')
                              : FileImage(imageFile!) as ImageProvider)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Offstage(
                  offstage: _visibility,
                  child: const CircularProgressIndicator(),
                ),
              ),
              Center(
                  child: ElevatedButton.icon(
                // splashColor: Colors.yellow,
                // shape: const StadiumBorder(),
                // color: Colors.black,
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(const StadiumBorder()),
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                  splashFactory: NoSplash.splashFactory,
                ),
                label: const Text(
                  'Add Image',
                  style: TextStyle(color: Colors.white),
                ),
                icon: const Icon(
                  Icons.add_a_photo,
                  color: Colors.white,
                ),
                onPressed: _showImageDialog,
              )),
            ],
          ),
        ),
      ),
    );
  }

  void compressImage() async {
    print('starting compression');
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);

    Im.Image? image = Im.decodeImage(imageFile!.readAsBytesSync());
    Im.copyResize(image!, width: 500, height: 500);

    var newim2 = File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));

    setState(() {
      imageFile = newim2;
    });
    print('done');
  }

  Future<GeoData?> locateUser() async {
    LocationData? currentLocation;
    Future<GeoData>? addresses;

    var location = Location();

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      currentLocation = await location.getLocation();

      print(
          'LATITUDE : ${currentLocation.latitude} && LONGITUDE : ${currentLocation.longitude}');

      // From coordinates
      // final coordinates =
      //      Coordinates(currentLocation.latitude, currentLocation.longitude);

      addresses = (Geocoder2.getDataFromCoordinates(
        latitude: currentLocation.latitude!,
        longitude: currentLocation.longitude!,
        googleMapApiKey: "GOOGLE_MAPS_API_KEY",
      ));

      //addresses = findAddressesFromCoordinates()
      //var kdkd = addresses.first;
    } on PlatformException catch (e) {
      print('ERROR : $e');
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
      currentLocation = null;
    }
    if (addresses != null) {
      return addresses;
    } else {
      return null;
    }
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
                  _pickImage('Gallery').then((selectedImage) async {
                    await ImageCropper.platform.cropImage(
                      sourcePath: selectedImage.path,
                      aspectRatioPresets: [
                        CropAspectRatioPreset.square,
                        // CropAspectRatioPreset.ratio3x2,
                        // CropAspectRatioPreset.original,
                        // CropAspectRatioPreset.ratio4x3,
                        // CropAspectRatioPreset.ratio16x9
                      ],
                    ).then((onValue) {
                      setState(() {
                        imageFile = onValue as File?;
                      });
                    });

                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: ((context) => UploadPhotoScreen(
                    //               imageFile: imageFile,
                    //             ))));
                    Navigator.of(context).pop();
                  });
                },
              ),
              SimpleDialogOption(
                child: const Text('Take Photo'),
                onPressed: () {
                  //Navigator.of(context).pop();
                  _pickImage('Camera').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage as File?;
                    });
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: ((context) => UploadPhotoScreen(
                    //               imageFile: imageFile,
                    //             ))));
                    Navigator.of(context).pop();
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

  //File imageFile;

  Future<XFile> _pickImage(String action) async {
    XFile selectedImage;

    action == 'Gallery'
        ? selectedImage =
            (await ImagePicker().pickImage(source: ImageSource.gallery))!
        : selectedImage =
            (await ImagePicker().pickImage(source: ImageSource.camera))!;

    return selectedImage;
  }
}
