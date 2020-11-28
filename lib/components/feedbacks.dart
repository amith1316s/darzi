import 'package:app_frontend/services/orderService.dart';
import 'package:flutter/material.dart';

class Feedbacks extends StatefulWidget {
  @override
  _FeedbacksState createState() => _FeedbacksState();
}

class _FeedbacksState extends State<Feedbacks> {
  OrderService orderService = OrderService();

  List feedbacks = [];

  @override
  void initState() {
    getFeedbacks();
    super.initState();
  }

  getFeedbacks() async {
    var data = await orderService.getFeedbacks();
    setState(() {
      feedbacks = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          'Feedbacks',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
              fontFamily: 'NovaSquare'),
        ),
        backgroundColor: Colors.white,
        elevation: 1.0,
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
          itemCount: feedbacks.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: Icon(Icons.comment),
                title: Text(feedbacks[index].data['feedback']),
              ),
            );
          }),
    );
  }
}
