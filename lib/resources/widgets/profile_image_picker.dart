import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImagePicker extends StatefulWidget {
  @override
  _ProfileImagePickerState createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50, // You can adjust image quality as needed
    );

    if (pickedFile != null) {
      final String fileExtension = pickedFile.path.split('.').last.toLowerCase();
      if (fileExtension == 'png' || fileExtension == 'jpg' || fileExtension == 'jpeg') {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      } else {
        // Show a dialog or a snackbar for invalid file type
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a PNG or JPG file')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
            child: _imageFile == null
                ? const Icon(
              Icons.person,
              size: 50,
              color: Colors.white,
            )
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0x70000000),
                ),
                child: const Text(
                  'Edit',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
