import 'package:app_frontend/services/userService.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'dart:collection';

class BodyMeasurementsService {
  UserService userService = new UserService();
  Firestore _firestore = Firestore.instance;

  Future<bool> addFemale(HashMap<String, dynamic> data) async {
    String uid = await userService.getUserId();

    await _firestore.collection('bodymeasurements').add({
      'userId': uid,
      'gender': 'Female',
      'bust': data['bust'],
      'waist': data['waist'],
      'hips': data['hips'],
      'lengthNeckToWaist': data['lengthNeckToWaist'],
      'lengthWeistToFinish': data['lengthWeistToFinish'],
      'inseam': data['inseam'],
      'crotchDepth': data['crotchDepth'],
    });

    return true;
  }

  Future<bool> updateFemale(HashMap<String, dynamic> data, String id) async {
    String uid = await userService.getUserId();

    await _firestore.collection('bodymeasurements').document(id).setData({
      'bust': data['bust'],
      'waist': data['waist'],
      'hips': data['hips'],
      'lengthNeckToWaist': data['lengthNeckToWaist'],
      'lengthWeistToFinish': data['lengthWeistToFinish'],
      'inseam': data['inseam'],
      'crotchDepth': data['crotchDepth'],
    }, merge: true);

    return true;
  }

  Future<bool> addMale(HashMap<String, dynamic> data) async {
    String uid = await userService.getUserId();

    await _firestore.collection('bodymeasurements').add({
      'userId': uid,
      'gender': 'Male',
      'chest': data['chest'],
      'waist': data['waist'],
      'hips': data['hips'],
      'lengthNeckToWaist': data['lengthNeckToWaist'],
      'rise': data['rise'],
      'outseam': data['outseam'],
    });

    return true;
  }

  Future<bool> updateMale(HashMap<String, dynamic> data, String id) async {
    String uid = await userService.getUserId();
    
    await _firestore.collection('bodymeasurements').document(id).setData({
      'chest': data['chest'],
      'waist': data['waist'],
      'hips': data['hips'],
      'lengthNeckToWaist': data['lengthNeckToWaist'],
      'rise': data['rise'],
      'outseam': data['outseam'],
    }, merge: true);

    return true;
  }

  Future<dynamic> getBodyMeasurements() async {
    String uid = await userService.getUserId();
    QuerySnapshot docRef = await _firestore
        .collection('bodymeasurements')
        .where('userId', isEqualTo: uid)
        .getDocuments();

    return docRef.documents.length > 0 ? docRef.documents[0] : null;
  }
}
