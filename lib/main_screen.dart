import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _picker = ImagePicker();
  XFile? _file;
  String _imageUrl = 'https://previews.123rf.com/images/pavelstasevich/pavelstasevich1811/pavelstasevich181101028/112815904-no-image-available-icon-flat-vector-illustration.jpg';

  void _getImage() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _file = file;
    });
  }

  void _uploadToStorage() async {
    final path = 'files/${_file?.name ?? "no file"}';
    final file = File(_file?.path ?? "");

    final ref = FirebaseStorage.instance.ref().child(path);
    final response = ref.putFile(file);
    final snapshot = await response.whenComplete(() {
      print("Yuklandi");
    });
    _imageUrl = await snapshot.ref.getDownloadURL();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Storage'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 150,
              width: 300,
              child: Center(
                child: _file == null
                    ? Icon(Icons.image)
                    : Image.file(
                  File(_file?.path ?? ""),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              height: 150,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 2, color: Colors.white12),
              ),
              child: Center(
                  child: _file == null
                      ? Image.network('https://thumbs.dreamstime.com/b/no-image-available-icon-isolated-dark-background-simple-vector-logo-no-image-available-icon-isolated-dark-background-275079095.jpg',
                    height: double.infinity,
                    width: double.infinity,
                  )
                      : Image.network(_imageUrl,height: double.infinity,width: double.infinity,)
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(onPressed: () {
              _getImage();
            }, icon: Icon(Icons.download), label: Text('Get Image')),
            const SizedBox(height: 10),
            ElevatedButton.icon(onPressed: () {
              _uploadToStorage();
            }, icon: Icon(Icons.upload), label: Text('Upload to Firebase')),
          ],
        ),
      ),
    );
  }
}