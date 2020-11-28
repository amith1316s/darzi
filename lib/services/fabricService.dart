import 'package:app_frontend/services/userService.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FabricService {
  UserService userService = new UserService();
  Firestore _firestore = Firestore.instance;


  Future<bool> add(
      String title, int price, String description, String image) async {
    String uid = await userService.getUserId();

    await _firestore.collection('fabrics').add({
      'userId': uid,
      'title': title,
      'price': price,
      'description': description,
      'image': image,
      'approved' : false
    });

    return true;
  }

  Future<List> fabricList() async {
    QuerySnapshot docRef = await _firestore
        .collection('fabrics')
        .getDocuments();
        return docRef.documents;
  }

}
