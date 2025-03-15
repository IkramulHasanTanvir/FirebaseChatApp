import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_real_time_data/common/constrants.dart';
import 'package:firebase_real_time_data/common/custom_navigator.dart';
import 'package:firebase_real_time_data/features/ui/home_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({
    super.key,
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  bool _isLoading = false;
  File? _image;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: background),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Complete Profile!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 40),
              Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 100,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? const Icon(Icons.person,
                        size: 100, color: Colors.grey)
                        : null,
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.camera_alt, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Upload Image',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 80),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _createAccount,
                child: const Text('COMPLETE PROFILE'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _createAccount() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a profile image before proceeding.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: widget.email,
        password: widget.password,
      );

      String filePath = 'users/${userCredential.user!.uid}/profile.jpg';
      UploadTask uploadTask = _storage.ref().child(filePath).putFile(_image!);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': widget.name,
        'email': widget.email,
        'profileImage': imageUrl,
        'createdAt': Timestamp.now(),
      });
      customNavigatorPushRemoveAll(context, const HomePage());

    } on FirebaseAuthException catch (e) {
      _showError(e.message);
    } catch (e) {
      _showError("An error occurred. Please try again.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message ?? "An error occurred")),
    );
  }
}
