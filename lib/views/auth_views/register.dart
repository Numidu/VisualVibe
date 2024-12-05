import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socially/model/userModel.dart';
import 'package:socially/service/users/userdtroge.dart';
import 'package:socially/service/users/userservice.dart';
import 'package:socially/views/responsive/utilits/constant/colors.dart';
import 'package:socially/widgets/reusable/Custominput.dart';
import 'package:socially/widgets/reusable/custombuttom.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  File? _imagefile;
  //image picker
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _imagefile = File(pickedImage.path);
      });
    }
  }

  Future<void> _createUser(BuildContext context) async {
    try {
      //store the user image in storage and get the download url
      if (_imagefile != null) {
        final imageUrl = await UserProfileStorageService().uploadImage(
          profileImage: _imagefile!,
          userEmail: _emailController.text,
        );
        _imageUrlController.text = imageUrl;
      }

      //save user to firestore
      UserService().saveUser(
        UserModel(
          userId: "",
          name: _nameController.text,
          email: _emailController.text,
          jobTitle: _jobTitleController.text,
          imageUrl: _imageUrlController.text,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          password: _passwordController.text,
          followers: 0,
        ),
      );

      //show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User created successfully'),
        ),
      );

      GoRouter.of(context).go('/mainscreen');
    } catch (e) {
      print('Error signing up with email and password: $e');
      //show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing up with email and password: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              const Image(
                image: AssetImage("assets/logo.png"),
                height: 40,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          _imagefile != null
                              ? CircleAvatar(
                                  radius: 64,
                                  backgroundColor: mainPurpleColor,
                                  backgroundImage: FileImage(_imagefile!),
                                )
                              : const CircleAvatar(
                                  radius: 64,
                                  backgroundColor: mainPurpleColor,
                                  backgroundImage: NetworkImage(
                                      'https://i.stack.imgur.com/l60Hf.png'),
                                ),
                          Positioned(
                              bottom: -10,
                              left: 80,
                              child: IconButton(
                                  onPressed: () async {
                                    _pickImage(ImageSource.gallery);
                                  },
                                  icon: Icon(Icons.add_a_photo))),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Custominput(
                      controller: _nameController,
                      labeltext: "Name",
                      icon: Icons.person,
                      obscuretext: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Custominput(
                      controller: _emailController,
                      labeltext: 'Email',
                      icon: Icons.email,
                      obscuretext: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Custominput(
                      controller: _jobTitleController,
                      labeltext: 'Job Title',
                      icon: Icons.work,
                      obscuretext: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your job title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Custominput(
                      controller: _passwordController,
                      labeltext: 'Password',
                      icon: Icons.lock,
                      obscuretext: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Custominput(
                      controller: _confirmPasswordController,
                      labeltext: 'Confirm Password',
                      icon: Icons.lock,
                      obscuretext: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Custombuttom(
                      text: 'Sign Up',
                      width: MediaQuery.of(context).size.width,
                      onpressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          await _createUser(context);
                        }
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextButton(
                        onPressed: () {
                          GoRouter.of(context).go("/login");
                        },
                        child: const Text(
                          'Already have account? Log in',
                          style: TextStyle(color: mainWhiteColor),
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
