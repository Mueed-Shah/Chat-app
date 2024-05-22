

import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

final _firebase = FirebaseAuth.instance;
File? selectedImage;

class AutScreen extends StatefulWidget {
  const AutScreen({super.key});

  @override
  State<AutScreen> createState() => _AutScreenState();
}

class _AutScreenState extends State<AutScreen> {
  var isLogin = true;
  final form = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _isAuthenticating = false;
  var _userName = '';

  void _submit() async {
    final isValid = form.currentState!.validate();

    if (!isValid || !isLogin && selectedImage==null) {
      return;
    }


    form.currentState!.save();
    try {
      setState(() {
        _isAuthenticating = true ;
      });
      if (isLogin) {
       final userCredential = await _firebase.signInWithEmailAndPassword(
            email: _email, password: _password);
        //set some logins
      } else {
        final userCredential = await _firebase.createUserWithEmailAndPassword(
            email: _email, password: _password);

        // creating a storage location for storing of images
       final storageRef = FirebaseStorage.instance.ref().child('user_images').
       child('${userCredential.user!.uid}.jpg');
       await storageRef.putFile(selectedImage!);
       final imageUrl = await storageRef.getDownloadURL();

       // creating a fireStore for meta data
       await FirebaseFirestore.instance.
       collection('users').doc(userCredential.user!.uid).set(
         {
           'user_name': _userName,
           'email': _email,
           'image_url' : imageUrl
         }
       );
      }
    } on FirebaseAuthException catch (error) {

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Authentication error'),
          ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 30, left: 20, right: 20, bottom: 20),
                width: 180,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if(!isLogin)
                           UserImagePicker(imagePicker: (image){
                            selectedImage = image;
                          }),
                          if(!isLogin)
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'Username' ),
                            validator: (value){
                              if(value == null || value.isEmpty || value.trim().length < 4){
                                return 'Enter a valid Name';
                              }
                              return null;
                            },
                            onSaved: (value){
                              _userName = value! ;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !value.contains('@')) {
                                return 'Enter valid email';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _email = value!;
                            },
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().length < 6) {
                                return 'Please enter valid password';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _password = value!;
                            },
                            obscureText: true,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          if(_isAuthenticating)
                            const CircularProgressIndicator(),
                          if(! _isAuthenticating)
                          ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer),
                              child: Text(isLogin ? 'Log_in' : 'Sign up')),
                          if(! _isAuthenticating)
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  isLogin = !isLogin;
                                });
                              },
                              child: Text(
                                isLogin
                                    ? 'Create an account'
                                    : 'I already have account',
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
