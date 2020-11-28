import 'dart:io';

import 'package:app_frontend/components/orders/orderHistory.dart';
import 'package:app_frontend/pages/body-measurements/body-measurements.dart';
import 'package:app_frontend/pages/home.dart';
import 'package:app_frontend/services/bodyMeasurementService.dart';
import 'package:app_frontend/services/fileUploadService.dart';
import 'package:app_frontend/services/orderService.dart';
import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:image_picker/image_picker.dart';

class AddOrder extends StatefulWidget {
  dynamic fabric;
  dynamic design;

  AddOrder({this.design, this.fabric});

  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  dynamic data;
  BodyMeasurementsService bodyMeasurementsService = BodyMeasurementsService();
  OrderService orderService = OrderService();
  String gender = "Male";

  File _image;
  String fileLocation = '';
  String customNotes;

  bool customDesign = false;

  FileUploadService fileUploadService = FileUploadService();

  @override
  void initState() {
    getMasurementsDataData();
    super.initState();
  }

  getMasurementsDataData() async {
    var res = await bodyMeasurementsService.getBodyMeasurements();
    if (res != null) {
      setState(() {
        data = res;
        gender = data['gender'];
      });
    }
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
            'Add Order',
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
            getMasurementsDataData();
          },
        ),
        body: Container(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 10.0),
                    child: Text(
                      'Fabric : ${widget.fabric['title']}',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          fontFamily: 'NovaSquare'),
                    ),
                  ),
                  widget.fabric['image'] != null
                      ? Image.network(widget.fabric['image'])
                      : Container(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 10.0),
                    child: Text(
                      'Design: ${customDesign ? '' : widget.design['title']}',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          fontFamily: 'NovaSquare'),
                    ),
                  ),
                  customDesign
                      ? Container()
                      : widget.design['image'] != null
                          ? Image.network(widget.design['image'])
                          : Container(),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: ButtonTheme(
                      minWidth: 180.0,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(36),
                            side: BorderSide(color: Colors.black)),
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        color: Colors.blue[800],
                        textColor: Colors.white,
                        child: Text(
                          'Add custom design',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          customDesign = true;
                          _pickImage(ImageSource.gallery);
                        },
                      ),
                    ),
                  ),
                  _image != null ? Image.file(_image) : Container(),
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
                  data != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 10.0),
                              child: Text(
                                'Body measurements',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                    fontFamily: 'NovaSquare'),
                              ),
                            ),
                            gender == "Male"
                                ? getMaleBodyMess()
                                : getFemaleBodyMess(),
                            Center(
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
                                    'Edit Body Measurements',
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BodyMeasurements()));
                                  },
                                ),
                              ),
                            )
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.only(left: 40, right: 40),
                          child: ButtonTheme(
                            minWidth: 180.0,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(36),
                                  side: BorderSide(color: Colors.black)),
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              color: Colors.blue[800],
                              textColor: Colors.white,
                              child: Text(
                                'Add Body Measurements',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            BodyMeasurements()));
                              },
                            ),
                          ),
                        ),
                  SizedBox(height: 30.0),
                  customDesign
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                          child: Text(
                            'Price: ${widget.design['price'] + widget.fabric['price']}',
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
                    child: TextFormField(
                      decoration: customFormField('Note'),
                      maxLines: 5,
                      keyboardType: TextInputType.text,
                      onChanged: (String val) {
                        customNotes = val;
                      },
                      style: TextStyle(fontSize: 17.0),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 40, right: 40, bottom: 40),
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
                          'Add order',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          if (customDesign) {
                            orderService.addCustom(
                                widget.fabric,
                                "https://firebasestorage.googleapis.com/v0/b/darzi-3f31a.appspot.com/o/$fileLocation?alt=media",
                                customNotes);
                          } else {
                            var price =
                                widget.design['price'] + widget.fabric['price'];
                            orderService.add(widget.fabric, widget.design,
                                customNotes, price);
                          }
                          _okayDialog();
                        },
                      ),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ));
  }

  getMaleBodyMess() {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 10.0),
            child: Text(
              'Chest: ${data['chest'].toString()}',
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontFamily: 'NovaSquare'),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 10.0),
            child: Text(
              'Waist: ${data['waist'].toString()}',
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontFamily: 'NovaSquare'),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 10.0),
            child: Text(
              'Hips: ${data['hips'].toString()}',
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontFamily: 'NovaSquare'),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 10.0),
            child: Text(
              'Length Neck To Waist: ${data['lengthNeckToWaist'].toString()}',
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontFamily: 'NovaSquare'),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 10.0),
            child: Text(
              'Rice: ${data['rice'].toString()}',
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontFamily: 'NovaSquare'),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 10.0),
            child: Text(
              'Outseam: ${data['outseam'].toString()}',
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontFamily: 'NovaSquare'),
            ),
          ),
        ],
      ),
    );
  }

  getFemaleBodyMess() {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 10.0),
            child: Text(
              'Bust: ${data['bust'].toString()}',
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontFamily: 'NovaSquare'),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 10.0),
            child: Text(
              'Waist: ${data['waist'].toString()}',
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontFamily: 'NovaSquare'),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 10.0),
            child: Text(
              'Hips: ${data['hips'].toString()}',
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontFamily: 'NovaSquare'),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 10.0),
            child: Text(
              'Length Neck To Waist: ${data['lengthNeckToWaist'].toString()}',
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontFamily: 'NovaSquare'),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 10.0),
            child: Text(
              'Length (waist to desired finished distance from floor): ${data['lengthWeistToFinish'].toString()}',
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontFamily: 'NovaSquare'),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 10.0),
            child: Text(
              'Inseam: ${data['inseam'].toString()}',
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontFamily: 'NovaSquare'),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 10.0),
            child: Text(
              'Crotch Depth: ${data['crotchDepth'].toString()}',
              style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontFamily: 'crotchDepth'),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    String filePath = '${DateTime.now()}.png';
    setState(() {
      _image = selected;
      fileLocation = filePath;
    });
    fileUploadService.upload(_image, filePath);
    return true;
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

  setBorder(double width, Color color) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(width: width, color: color));
  }

  Future<void> _okayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Your Order Successfully Added'),
                Icon(Icons.domain_verification, color: Colors.blueAccent,size: 100,)
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('ok'),
              onPressed: () async {
                Navigator.pop(context);

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Home()));
              },
            ),
          ],
        );
      },
    );
  }
}
