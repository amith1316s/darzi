import 'package:app_frontend/services/orderService.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:app_frontend/components/header.dart';
import 'package:app_frontend/components/sidebar.dart';

class OrderHistory extends StatefulWidget {
  String role;
  OrderHistory({this.role});

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  OrderService orderService = OrderService();
  List orders = [];

  String status = '';
  String trackingNumber = '';
  String feedback = '';
  String quotation = '';

  @override
  void initState() {
    getOrders();
    super.initState();
  }

  getOrders() async {
    var data;
    if (widget.role == 'user') {
      data = await orderService.orderListForUser();
    } else if (widget.role == 'seller') {
      data = await orderService.orderListForSeller();
    } else if (widget.role == 'admin') {
      data = await orderService.orderListForAdmin();
    }
    setState(() {
      orders = data;
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
          'My Orders',
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.refresh,
          color: Colors.blueAccent,
        ),
        onPressed: () {
          getOrders();
        },
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          var fabric = orders[index].data['fabric'];
          var design = orders[index].data['design'];
          var customOrder = orders[index].data['type'] == 'custom';
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 10.0),
                      child: Text(
                        'Fabric : ${fabric['title']}',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            fontFamily: 'NovaSquare'),
                      ),
                    ),
                    fabric['image'] != null
                        ? Image.network(fabric['image'])
                        : Container(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 10.0),
                      child: Text(
                        'Designs: ${customOrder ? '' : design['title']}',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            fontFamily: 'NovaSquare'),
                      ),
                    ),
                    customOrder
                        ? orders[index].data['customDesign'] != null
                            ? Image.network(orders[index].data['customDesign'])
                            : Container()
                        : design['image'] != null
                            ? Image.network(design['image'])
                            : Container(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 10.0),
                      child: Text(
                        'Body measurements',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            fontFamily: 'NovaSquare'),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Price: ${orders[index].data['price'] ?? '0'}',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            fontFamily: 'NovaSquare'),
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 10.0),
                      child: Text(
                        'Notes',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            fontFamily: 'NovaSquare'),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
                        child: Text(orders[index].data['note'] ?? '')),
                    Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
                        child: Text('Status: ${orders[index].data['status']}')),
                    Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 15.0),
                        child: Text(
                            'Tracking number: ${orders[index].data['trackingNumber']}')),
                    Divider(
                      thickness: 3,
                    ),
                    widget.role == 'user'
                        ? Column(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                                child: TextFormField(
                                  decoration: customFormField('Feedback'),
                                  keyboardType: TextInputType.text,
                                  onChanged: (String val) {
                                    feedback = val;
                                  },
                                  style: TextStyle(fontSize: 17.0),
                                ),
                              ),
                              Center(
                                child: ButtonTheme(
                                  minWidth: 250.0,
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(36),
                                        side: BorderSide(color: Colors.black)),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    color: Colors.blue[800],
                                    textColor: Colors.white,
                                    child: Text(
                                      'Add feedback',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () async {
                                      await orderService.addFeedback(
                                          orders[index].data['sellerId'],
                                          feedback);
                                          _popupDialog('Successfully added feedback');
                                    },
                                  ),
                                ),
                              )
                            ],
                          )
                        : Container(),
                    ( widget.role == 'user' ||
                            widget.role == 'admin') &&
                                customOrder &&
                                orders[index].data['status'] == 'approved' &&
                                orders[index].data['quotation'] != null
                        ? Container(
                            height: 180,
                            child: ListView.builder(
                                itemCount:
                                    orders[index].data['quotation'].length,
                                itemBuilder: (context, i) {
                                  return Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Center(
                                            child: Text(orders[index]
                                                .data['quotation'][i]
                                                    ['quotation']
                                                .toString()),
                                          )),
                                      Expanded(
                                        flex: 2,
                                        child: FlatButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(36),
                                              side: BorderSide(
                                                  color: Colors.black)),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          color: Colors.blue[800],
                                          textColor: Colors.white,
                                          child: Text(
                                            'Confirm',
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onPressed: () async {
                                            await orderService.confirmQuotation(
                                                orders[index].documentID,
                                                orders[index].data['quotation']
                                                    [i]['sellerId'],
                                                orders[index].data['quotation']
                                                    [i]['quotation']);
                                            getOrders();
                                          },
                                        ),
                                      )
                                    ],
                                  );
                                }),
                          )
                        : Container(),
                    widget.role == 'seller' &&
                            customOrder &&
                            orders[index].data['status'] == 'approved'
                        ? Column(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                                child: TextFormField(
                                  decoration: customFormField('Quotation'),
                                  keyboardType: TextInputType.number,
                                  onChanged: (String val) {
                                    quotation = val;
                                  },
                                  style: TextStyle(fontSize: 17.0),
                                ),
                              ),
                              Center(
                                child: ButtonTheme(
                                  minWidth: 250.0,
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(36),
                                        side: BorderSide(color: Colors.black)),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    color: Colors.blue[800],
                                    textColor: Colors.white,
                                    child: Text(
                                      'Add quotation',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () async {
                                      await orderService.addQuotation(
                                          orders[index].documentID, quotation);
                                          _popupDialog('Successfully added quotation');
                                    },
                                  ),
                                ),
                              )
                            ],
                          )
                        : Container(),
                    widget.role == 'seller' &&
                            orders[index].data['status'] == 'pending' &&
                            !customOrder
                        ? Center(
                            child: ButtonTheme(
                              minWidth: 250.0,
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(36),
                                    side: BorderSide(color: Colors.black)),
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                color: Colors.blue[800],
                                textColor: Colors.white,
                                child: Text(
                                  'Accept',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () async {
                                  await orderService
                                      .acceptSeller(orders[index].documentID);
                                  getOrders();
                                },
                              ),
                            ),
                          )
                        : Container(),
                    widget.role == 'admin' &&
                            orders[index].data['status'] == 'pending' &&
                            customOrder
                        ? Center(
                            child: ButtonTheme(
                              minWidth: 250.0,
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(36),
                                    side: BorderSide(color: Colors.black)),
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                color: Colors.blue[800],
                                textColor: Colors.white,
                                child: Text(
                                  'Approve custom order',
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () async {
                                  await orderService.approveCustomOrder(
                                      orders[index].documentID);
                                  getOrders();
                                },
                              ),
                            ),
                          )
                        : Container(),
                    widget.role == 'seller' &&
                                (orders[index].data['status'] == 'Accepted' ||
                            orders[index].data['status'] == 'ongoing' ||
                            orders[index].data['status'] == 'dispatched')
                        ? Column(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                                child: TextFormField(
                                  decoration:
                                      customFormField('Tracking number'),
                                  keyboardType: TextInputType.text,
                                  onChanged: (String val) {
                                    trackingNumber = val;
                                  },
                                  style: TextStyle(fontSize: 17.0),
                                ),
                              ),
                              Text(
                                  'Update tracking number if you are going to dispatch'),
                              Padding(
                                  // ['ongoing', 'dispatched', 'completed', 'cancel']
                                  padding: EdgeInsets.fromLTRB(
                                      15.0, 15.0, 15.0, 15.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Radio(
                                            value: "ongoing",
                                            activeColor: Colors.blueAccent,
                                            groupValue: status,
                                            onChanged: (val) {
                                              setState(() {
                                                status = val;
                                              });
                                            },
                                          ),
                                          Text(
                                            "Ongoing",
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: "dispatched",
                                            activeColor: Colors.blueAccent,
                                            groupValue: status,
                                            onChanged: (val) {
                                              setState(() {
                                                status = val;
                                              });
                                            },
                                          ),
                                          Text(
                                            "Dispatched",
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: "completed",
                                            activeColor: Colors.blueAccent,
                                            groupValue: status,
                                            onChanged: (val) {
                                              setState(() {
                                                status = val;
                                              });
                                            },
                                          ),
                                          Text(
                                            "Completed",
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: "Cancel",
                                            activeColor: Colors.blueAccent,
                                            groupValue: status,
                                            onChanged: (val) {
                                              setState(() {
                                                status = val;
                                              });
                                            },
                                          ),
                                          Text(
                                            "Cancel",
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                              Center(
                                child: ButtonTheme(
                                  minWidth: 250.0,
                                  child: FlatButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(36),
                                        side: BorderSide(color: Colors.black)),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    color: Colors.blue[800],
                                    textColor: Colors.white,
                                    child: Text(
                                      'Update',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () async {
                                      await orderService.updateOrderSeller(
                                          orders[index].documentID,
                                          status,
                                          trackingNumber);
                                          _popupDialog('Successfully updated order');
                                      getOrders();
                                    },
                                  ),
                                ),
                              )
                            ],
                          )
                        : Container()
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  InputDecoration customFormField(String hintText) {
    return InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.all(20.0),
        errorBorder: this.setBorder(1.0, Colors.red),
        focusedErrorBorder: this.setBorder(1.0, Colors.red),
        focusedBorder: this.setBorder(2.0, Colors.blue),
        enabledBorder: this.setBorder(1.0, Colors.black));
  }

  Future<void> _popupDialog(message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message ?? " "),
                Icon(Icons.domain_verification, color: Colors.blueAccent,size: 100,)
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('ok'),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  setBorder(double width, Color color) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(width: width, color: color));
  }
}
