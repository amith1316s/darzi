import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FileUploadService {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: "gs://darzi-3f31a.appspot.com");

  StorageUploadTask _storageUploadTask;

  void upload(File file, String filePath) async {
    _storageUploadTask = _storage.ref().child(filePath).putFile(file);
  }
}
