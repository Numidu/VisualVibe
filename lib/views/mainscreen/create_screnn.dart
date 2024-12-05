import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socially/model/userModel.dart';
import 'package:socially/service/feed/feed_service.dart';
import 'package:socially/service/users/userservice.dart';
import 'package:socially/views/responsive/utilits/mode.dart';
import 'package:socially/widgets/reusable/custombuttom.dart';
import 'package:socially/widgets/reusable/custominput.dart';

class CreateScrenn extends StatefulWidget {
  const CreateScrenn({super.key});

  @override
  State<CreateScrenn> createState() => _CreateScrennState();
}

class _CreateScrennState extends State<CreateScrenn> {
  final _formKey = GlobalKey();
  final TextEditingController _captioncontrall = TextEditingController();
  File? _imageFile;
  Mood selectMood = Mood.happy;
  bool isUploading = false;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _imageFile =
            File(pickedImage.path); // 4to aragena me variable eka update wenwa
      });
    }
  }

// submit form to database
  void _submitpost() async {
    try {
      setState(() {
        isUploading = true;
      });
      if (kIsWeb) {
        return;
      }
      final String postCaption = _captioncontrall.text;
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final UserModel? userdata =
            await UserService().getUserByUserId(userId: user.uid);
        if (userdata != null) {
          // post details tika denwa
          final postDetails = {
            "postCaption": postCaption,
            "mood": selectMood.name,
            "userId": userdata.userId,
            "userName": userdata.name,
            "profImage": userdata.imageUrl,
            "postImage": _imageFile,
          };
          await FeedService().savepost(postDetails);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User  successfully'),
            ),
          );
        }
      }
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('post failed'),
        ),
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("create post"),
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Custominput(
                  controller: _captioncontrall,
                  labeltext: "caption",
                  icon: Icons.text_fields,
                  obscuretext: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please enter caption";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 60,
                ),
                DropdownButton<Mood>(
                  value: selectMood,
                  items: Mood.values.map((Mood mood) {
                    return DropdownMenuItem(
                        child: Text("${mood.name} ${mood.emoji}"), value: mood);
                  }).toList(),
                  onChanged: (Mood? newMood) {
                    selectMood = newMood ?? selectMood;
                  },
                ),
                const SizedBox(
                  height: 60,
                ),
                _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: kIsWeb // chek krnw web eked kiyla
                            ? Image.network(_imageFile!.path)
                            : Image.file(_imageFile!),
                      )
                    : const Text("no image"),
                const SizedBox(
                  height: 60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Custombuttom(
                      text: "Use camera",
                      width: MediaQuery.of(context).size.width * 0.43,
                      onpressed: () => _pickImage(ImageSource.camera),
                    ),
                    Custombuttom(
                      text: "Use gallery",
                      width: MediaQuery.of(context).size.width * 0.43,
                      onpressed: () => _pickImage(ImageSource.gallery),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                  ],
                ),
                Custombuttom(
                  text: kIsWeb
                      ? "Not supported yet"
                      : isUploading
                          ? "uploading"
                          : "create post",
                  width: MediaQuery.of(context).size.width,
                  onpressed: () {
                    _submitpost();
                  },
                )
              ],
            ),
          )),
    );
  }
}
