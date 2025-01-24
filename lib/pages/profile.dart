import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_curso/controllers/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'dart:convert';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  XFile? _image;
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await loadLocalImage();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> setImage(XFile image) async {
    final bytes = await image.readAsBytes();
    setState(() {
      _image = image;
      _imageBytes = bytes;
    });

    if (_imageBytes != null) {
      saveLocalImage(base64Encode(_imageBytes!));
    }
  }

  Future<void> saveLocalImage(String value) async {
    GetStorage box = GetStorage();
    box.write('userImageProfile', value);
  }

  Future<void> loadLocalImage() async {
    GetStorage box = GetStorage();
    final String? value = box.read('userImageProfile');
    if (value != null) {
      setState(() {
        _imageBytes = base64Decode(value);
      });
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Center(
        child: ProfileScreen(
          avatar: IconButton(
            iconSize: 130,
            icon: _imageBytes != null
                ? ClipOval(
                    child: Image.memory(
                      _imageBytes!,
                      width: 130,
                      height: 130,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(Icons.account_circle, size: 130),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Escolha uma opção'),
                    content: SingleChildScrollView(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () async {
                              Navigator.of(context).pop();
                              final ImagePicker picker = ImagePicker();
                              final XFile? image = await picker.pickImage(
                                  source: ImageSource.gallery);
                              if (image != null) {
                                await setImage(image);
                              }
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Icon(Icons.photo, size: 50),
                                    Text('Galeria'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              Navigator.of(context).pop();
                              final ImagePicker picker = ImagePicker();
                              final XFile? photo = await picker.pickImage(
                                  source: ImageSource.camera);
                              if (photo != null) {
                                await setImage(photo);
                              }
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Icon(Icons.camera_alt, size: 50),
                                    Text('Câmera'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          actions: [
            SignedOutAction(((context) async {
              Get.find<UserController>().userToken.value = '';
              await Get.offNamed('/auth');
            })),
            AccountDeletedAction((context, user) async {
              Get.find<UserController>().userToken.value = '';
              await Get.offNamed('/auth');
            }),
          ],
        ),
      ),
    );
  }
}
