import 'package:app_frontend/services/userService.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class OrderService {
  UserService userService = new UserService();
  Firestore _firestore = Firestore.instance;

  Future<bool> add(
      dynamic fabric, dynamic design, String note, int price) async {
    String uid = await userService.getUserId();

    await _firestore.collection('orders').add({
      'userId': uid,
      'sellerId': design['userId'],
      'fabric': fabric,
      'design': design,
      'note': note,
      'status': 'pending',
      'trackingNumber': '',
      'approved': false,
      'price': price,
      'type': 'normal'
    });

    return true;
  }

  Future<bool> addCustom(
      dynamic fabric, String fileLocation, String note) async {
    String uid = await userService.getUserId();

    await _firestore.collection('orders').add({
      'userId': uid,
      'sellerId': '',
      'fabric': fabric,
      'customDesign': fileLocation,
      'note': note,
      'status': 'pending',
      'trackingNumber': '',
      'approved': false,
      'price': 0,
      'type': 'custom'
    });

    return true;
  }

  Future<List> orderListForUser() async {
    String uid = await userService.getUserId();
    QuerySnapshot docRef = await _firestore
        .collection('orders')
        .where('userId', isEqualTo: uid)
        .getDocuments();
    return docRef.documents;
  }

  Future<List> getFeedbacks() async {
    String uid = await userService.getUserId();
    QuerySnapshot docRef = await _firestore
        .collection('feedbacks')
        .where('sellerId', isEqualTo: uid)
        .getDocuments();
    return docRef.documents;
  }

  Future<List> orderListForSeller() async {
    String uid = await userService.getUserId();
    QuerySnapshot docRef = await _firestore
        .collection('orders')
        .where('sellerId', isEqualTo: uid)
        .getDocuments();

        QuerySnapshot docRef2 = await _firestore
        .collection('orders')
        .where('type', isEqualTo: 'custom')
        .where('status', isEqualTo: 'approved')
        .getDocuments();
    return docRef.documents + docRef2.documents;
  }

  Future<List> orderListForAdmin() async {
    String uid = await userService.getUserId();
    QuerySnapshot docRef = await _firestore.collection('orders').getDocuments();
    return docRef.documents;
  }

  Future<bool> acceptSeller(String id) async {
    String uid = await userService.getUserId();

    await _firestore.collection('orders').document(id).setData({
      'status': 'Accepted',
    }, merge: true);

    return true;
  }

   Future<bool> approveCustomOrder(String id) async {
    String uid = await userService.getUserId();

    await _firestore.collection('orders').document(id).setData({
      'status': 'approved',
    }, merge: true);

    return true;
  }
  

  Future<bool> updateOrderSeller(
      String id, String status, String trackingNumber) async {
    String uid = await userService.getUserId();

    await _firestore.collection('orders').document(id).setData(
        {'status': status, 'trackingNumber': trackingNumber, },
        merge: true);

    return true;
  }

  Future<bool> confirmQuotation(String id, 
      String sellerId, String quotation) async {
    String uid = await userService.getUserId();

    await _firestore.collection('orders').document(id).setData(
        {'sellerId': sellerId, 'price': int.parse(quotation), 'status': 'Accepted'},
        merge: true);

    return true;
  }

  Future<bool> addQuotation(
      String id, String quotation) async {
    String uid = await userService.getUserId();

    var list = [
      {'sellerId': uid, 'quotation': quotation}
    ];

    await _firestore
        .collection('orders')
        .document(id)
        .updateData({'quotation': FieldValue.arrayUnion(list)});

    return true;
  }

  Future<bool> addFeedback(String sellerId, String feedback) async {
    String uid = await userService.getUserId();

    await _firestore.collection('feedbacks').add({
      'userId': uid,
      'sellerId': sellerId,
      'feedback': feedback,
    });

    return true;
  }
}
