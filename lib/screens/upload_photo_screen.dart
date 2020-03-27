import 'dart:async';
import 'dart:io';
import 'package:HFM/resources/repository.dart';
import 'package:HFM/screens/home.dart';
import 'package:HFM/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'dart:math';

class UploadPhotoScreen extends StatefulWidget {
  // File imageFile;
  // UploadPhotoScreen({this.imageFile});

  @override
  _UploadPhotoScreenState createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  File imageFile;
  var _locationController;
  var _captionController;
  final _repository = Repository();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _locationController = TextEditingController();
    _captionController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _locationController?.dispose();
    _captionController?.dispose();
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
        title: Text(
          'New Post',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: colortheme.primaryColor,
        elevation: 1.0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 0.0),
            child: GestureDetector(
              child: Icon(
                Icons.send,
                color: colortheme.accentColor,
              ),
              onTap: () {
                // To show the CircularProgressIndicator
                _changeVisibility(false);

                _repository.getCurrentUser().then((currentUser) {
                  if (currentUser != null && imageFile != null) {
                    compressImage();
                    _repository.retrieveUserDetails(currentUser).then((user) {
                      _repository
                          .uploadImageToStorage(imageFile)
                          .then((url) {
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
                  } else if(currentUser != null && imageFile == null){
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
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                    child: TextField(
                      controller: _captionController,
                      //maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          hintText: 'Write a message...',
                          contentPadding:
                              EdgeInsets.only(bottom: 100, top: 16)),
                      onChanged: ((value) {
                        setState(() {
                          _captionController.text = value;
                        });
                      }),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _locationController,
                onChanged: ((value) {
                  setState(() {
                    _locationController.text = value;
                  });
                }),
                decoration: InputDecoration(
                  hintText: 'Add location',
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            //   child: FutureBuilder(
            //       future: locateUser(),
            //       builder: ((context, AsyncSnapshot<List<Address>> snapshot) {
            //         //  if (snapshot.hasData) {
            //         if (snapshot.hasData) {
            //           return Row(
            //             // alignment: WrapAlignment.start,
            //             children: <Widget>[
            //               GestureDetector(
            //                 child: Chip(
            //                   label: Text(
            //                     snapshot.data.first.locality == null
            //                     ? 'No location found'
            //                     :  snapshot.data.first.locality
            //                   ),
            //                 ),
            //                 onTap: () {
            //                   setState(() {
            //                     _locationController.text =
            //                         snapshot.data.first.locality;
            //                   });
            //                 },
            //               ),
            //               Padding(
            //                 padding: const EdgeInsets.only(left: 12.0),
            //                 child: GestureDetector(
            //                   child: Chip(
            //                     label: Text(
            //                       snapshot.data.first.subAdminArea == null
            //                       ? 'No sub Area found'
            //                       : snapshot.data.first.subAdminArea
            //                       + ", " +
            //                       snapshot.data.first.subLocality == null
            //                       ? 'No sub-locality found'
            //                       : snapshot.data.first.subLocality),
            //                   ),
            //                   onTap: () {
            //                     setState(() {
            //                       _locationController.text =
            //                           snapshot.data.first.subAdminArea +
            //                               ", " +
            //                               snapshot.data.first.subLocality;
            //                     });
            //                   },
            //                 ),
            //               ),
            //             ],
            //           );
            //         } else {
            //           print("Connection State : ${snapshot.connectionState}");
            //           return CircularProgressIndicator();
            //         }
            //       })),
            // ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover, 
                        image: imageFile == null
                        ? AssetImage('') 
                        : FileImage(imageFile))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Offstage(
                child: CircularProgressIndicator(),
                offstage: _visibility,
              ),
            ),
            Center(
                child: RaisedButton.icon(
              splashColor: Colors.yellow,
              shape: StadiumBorder(),
              color: Colors.black,
              label: Text(
                'Add Image',
                style: TextStyle(color: Colors.white),
              ),
              icon: Icon(
                Icons.add_a_photo,
                color: Colors.white,
              ),
              onPressed: _showImageDialog,
            )),
          ],
        ),
      ),
    );
  }

  void compressImage() async {
    print('starting compression');
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);

    Im.Image image = Im.decodeImage(imageFile.readAsBytesSync());
    Im.copyResize(image);

    var newim2 = new File('$path/img_$rand.jpg')
      ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));

    setState(() {
      imageFile = newim2;
    });
    print('done');
  }

  Future<List<Address>> locateUser() async {
    LocationData currentLocation;
    Future<List<Address>> addresses;

    var location = new Location();

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      currentLocation = await location.getLocation();

      print(
          'LATITUDE : ${currentLocation.latitude} && LONGITUDE : ${currentLocation.longitude}');

      // From coordinates
      final coordinates =
          new Coordinates(currentLocation.latitude, currentLocation.longitude);

      addresses = (Geocoder.local.findAddressesFromCoordinates(coordinates));

      //addresses = findAddressesFromCoordinates()
      //var kdkd = addresses.first;
    } on PlatformException catch (e) {
      print('ERROR : $e');
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
      currentLocation = null;
    }
    return addresses;
  }

  _showImageDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Choose from Gallery'),
                onPressed: () {
                  //Navigator.pop(context);
                  _pickImage('Gallery').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
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
                child: Text('Take Photo'),
                onPressed: () {
                  //Navigator.of(context).pop();
                  _pickImage('Camera').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
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
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }

  //File imageFile;

  Future<File> _pickImage(String action) async {
    File selectedImage;

    action == 'Gallery'
        ? selectedImage =
            await ImagePicker.pickImage(source: ImageSource.gallery)
        : selectedImage =
            await ImagePicker.pickImage(source: ImageSource.camera);

    return selectedImage;
  }
}
