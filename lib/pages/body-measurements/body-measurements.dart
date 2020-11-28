import 'dart:io';

import 'package:app_frontend/services/bodyMeasurementService.dart';
import 'package:app_frontend/services/fileUploadService.dart';
import 'package:app_frontend/services/validateService.dart';
import 'package:app_frontend/services/designService.dart';
import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:image_picker/image_picker.dart';

class BodyMeasurements extends StatefulWidget {
  @override
  _BodyMeasurementsState createState() => _BodyMeasurementsState();
}

class _BodyMeasurementsState extends State<BodyMeasurements> {
  HashMap bodyMeasurementsData = new HashMap<String, dynamic>();
  ValidateService validateService = ValidateService();
  BodyMeasurementsService bodyMeasurementsService = BodyMeasurementsService();
  String gender = "Male";
  bool newM = true;
  String docID = "";
  var x = 10;

  TextEditingController maleChest = new TextEditingController();
  TextEditingController maleWaist = new TextEditingController();
  TextEditingController maleHips = new TextEditingController();
  TextEditingController maleLengthNeckToWaist = new TextEditingController();
  TextEditingController maleRise = new TextEditingController();
  TextEditingController maleOutseam = new TextEditingController();

  TextEditingController femaleBust = new TextEditingController();
  TextEditingController femaleWaist = new TextEditingController();
  TextEditingController femaleHips = new TextEditingController();
  TextEditingController femaleLengthNeckToWaist = new TextEditingController();
  TextEditingController femaleLengthWeistToFinish = new TextEditingController();
  TextEditingController femaleInseam = new TextEditingController();
  TextEditingController femaleCrotchDepth = new TextEditingController();

  @override
  void initState() {
    getMasurementsDataData();
    super.initState();
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
          'Body Measurements',
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
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Column(
              children: <Widget>[
                Container(
                  height: 40.0,
                  alignment: Alignment.topCenter,
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 10.0),
                        child: Text(
                          'Gender',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              fontFamily: 'NovaSquare'),
                        ),
                      ),
                      Radio(
                        value: "Male",
                        activeColor: Colors.blueAccent,
                        groupValue: gender,
                        onChanged: (val) {
                          setState(() {
                            gender = val;
                          });
                        },
                      ),
                      Text(
                        "Male",
                      ),
                      Radio(
                        value: "Female",
                        activeColor: Colors.blueAccent,
                        groupValue: gender,
                        onChanged: (val) {
                          setState(() {
                            gender = val;
                          });
                        },
                      ),
                      Text(
                        "Female",
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.0),
                gender == 'Male' ? getMaleMesurements() : getFemaleMesurements()
              ],
            )),
      ),
    );
  }

  getMasurementsDataData() async {
    var data = await bodyMeasurementsService.getBodyMeasurements();
    if (data != null) {
      setState(() {
        newM = false;
        docID = data.documentID;
        gender = data['gender'];
        if (gender == 'Female') {
          femaleBust.text = data['bust'].toString();
          femaleWaist.text = data['waist'].toString();
          femaleHips.text = data['hips'].toString();
          femaleLengthNeckToWaist.text = data['lengthNeckToWaist'].toString();
          femaleLengthWeistToFinish.text =
              data['lengthWeistToFinish'].toString();
          femaleInseam.text = data['inseam'].toString();
          femaleCrotchDepth.text = data['crotchDepth'].toString();

          bodyMeasurementsData['bust'] = data['bust'].toString();
          bodyMeasurementsData['waist'] = data['waist'].toString();
          bodyMeasurementsData['hips'] = data['hips'].toString();
          bodyMeasurementsData['lengthNeckToWaist'] = data['lengthNeckToWaist'].toString();
          bodyMeasurementsData['lengthWeistToFinish'] = data['lengthWeistToFinish'].toString();
          bodyMeasurementsData['inseam'] = data['inseam'].toString();
          bodyMeasurementsData['crotchDepth'] = data['crotchDepth'].toString();
        } else if (gender == 'Male') {
          maleChest.text = data['chest'].toString();
          maleWaist.text = data['waist'].toString();
          maleHips.text = data['hips'].toString();
          maleLengthNeckToWaist.text = data['lengthNeckToWaist'].toString();
          maleRise.text = data['rise'].toString();
          maleOutseam.text = data['outseam'].toString();

          bodyMeasurementsData['chest'] = data['chest'].toString();
          bodyMeasurementsData['waist'] = data['waist'].toString();
          bodyMeasurementsData['hips'] = data['hips'].toString();
          bodyMeasurementsData['lengthNeckToWaist'] = data['lengthNeckToWaist'].toString();
          bodyMeasurementsData['rise'] = data['rise'].toString();
          bodyMeasurementsData['outseam'] = data['outseam'].toString();
        }
      });
    }
  }

  getMaleMesurements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          decoration: customFormField('Chest'),
          controller: maleChest,
          keyboardType: TextInputType.number,
          validator: (value) => validateService.isEmptyField(value),
          onChanged: (String val) {
            bodyMeasurementsData['chest'] = int.parse(val);
          },
          style: TextStyle(fontSize: 17.0),
        ),
        Text('Measured under the arms'),
        SizedBox(height: 30.0),
        TextFormField(
          decoration: customFormField('Waist'),
          controller: maleWaist,
          keyboardType: TextInputType.number,
          validator: (value) => validateService.isEmptyField(value),
          onChanged: (String val) {
            bodyMeasurementsData['waist'] = int.parse(val);
          },
          style: TextStyle(fontSize: 17.0),
        ),
        Text('Measured slightly below the navel '),
        SizedBox(height: 30.0),
        TextFormField(
          decoration: customFormField('Hips/Seat'),
          controller: maleHips,
          keyboardType: TextInputType.number,
          validator: (value) => validateService.isEmptyField(value),
          onChanged: (String val) {
            bodyMeasurementsData['hips'] = int.parse(val);
          },
          style: TextStyle(fontSize: 17.0),
        ),
        Text('Measured approximately 6” below the waist '),
        SizedBox(height: 30.0),
        TextFormField(
          decoration: customFormField('Length (neck to waist)'),
          controller: maleLengthNeckToWaist,
          keyboardType: TextInputType.number,
          validator: (value) => validateService.isEmptyField(value),
          onChanged: (String val) {
            bodyMeasurementsData['lengthNeckToWaist'] = int.parse(val);
          },
          style: TextStyle(fontSize: 17.0),
        ),
        Text('Measured down the spine '),
        SizedBox(height: 30.0),
        TextFormField(
          decoration: customFormField('Rise'),
          controller: maleRise,
          keyboardType: TextInputType.number,
          validator: (value) => validateService.isEmptyField(value),
          onChanged: (String val) {
            bodyMeasurementsData['rise'] = int.parse(val);
          },
          style: TextStyle(fontSize: 17.0),
        ),
        Text('The difference between the outseam and the inseam '),
        SizedBox(height: 30.0),
        TextFormField(
          decoration: customFormField('Outseam'),
          controller: maleOutseam,
          keyboardType: TextInputType.number,
          validator: (value) => validateService.isEmptyField(value),
          onChanged: (String val) {
            bodyMeasurementsData['outseam'] = int.parse(val);
          },
          style: TextStyle(fontSize: 17.0),
        ),
        Text(
            'Measured on the side from waist to floor, on the outside of the leg '),
        SizedBox(height: 30.0),
        ButtonTheme(
          minWidth: 180.0,
          child: FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(36),
                side: BorderSide(color: Colors.black)),
            padding: EdgeInsets.symmetric(vertical: 10.0),
            color: Colors.blue[800],
            textColor: Colors.white,
            child: Text(
              'Save',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              newM
                  ? bodyMeasurementsService.addMale(bodyMeasurementsData)
                  : bodyMeasurementsService.updateMale(
                      bodyMeasurementsData, docID);
              Navigator.pop(context);
            },
          ),
        )
      ],
    );
  }

  getFemaleMesurements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          decoration: customFormField('Bust (chest)'),
          controller: femaleBust,
          keyboardType: TextInputType.number,
          validator: (value) => validateService.isEmptyField(value),
          onChanged: (String val) {
            bodyMeasurementsData['bust'] = int.parse(val);
          },
          style: TextStyle(fontSize: 17.0),
        ),
        Text('Measured at the nipple line '),
        SizedBox(height: 30.0),
        TextFormField(
          decoration: customFormField('Waist'),
          controller: femaleWaist,
          keyboardType: TextInputType.number,
          validator: (value) => validateService.isEmptyField(value),
          onChanged: (String val) {
            bodyMeasurementsData['waist'] = int.parse(val);
          },
          style: TextStyle(fontSize: 17.0),
        ),
        Text('Measured at the narrowest point '),
        SizedBox(height: 30.0),
        TextFormField(
          decoration: customFormField('Hips'),
          controller: femaleHips,
          keyboardType: TextInputType.number,
          validator: (value) => validateService.isEmptyField(value),
          onChanged: (String val) {
            bodyMeasurementsData['hips'] = int.parse(val);
          },
          style: TextStyle(fontSize: 17.0),
        ),
        Text('Measured at the broadest (largest) point '),
        SizedBox(height: 30.0),
        TextFormField(
          decoration: customFormField('Length (neck to waist)'),
          controller: femaleLengthNeckToWaist,
          keyboardType: TextInputType.number,
          validator: (value) => validateService.isEmptyField(value),
          onChanged: (String val) {
            bodyMeasurementsData['lengthNeckToWaist'] = int.parse(val);
          },
          style: TextStyle(fontSize: 17.0),
        ),
        Text('Measured down the spine '),
        SizedBox(height: 30.0),
        TextFormField(
          decoration: customFormField(
              'Length (waist to desired finished distance from floor)'),
          controller: femaleLengthWeistToFinish,
          keyboardType: TextInputType.number,
          validator: (value) => validateService.isEmptyField(value),
          onChanged: (String val) {
            bodyMeasurementsData['lengthWeistToFinish'] = int.parse(val);
          },
          style: TextStyle(fontSize: 17.0),
        ),
        Text('Measured down the spine '),
        SizedBox(height: 30.0),
        TextFormField(
          decoration: customFormField('Inseam'),
          controller: femaleInseam,
          keyboardType: TextInputType.number,
          validator: (value) => validateService.isEmptyField(value),
          onChanged: (String val) {
            bodyMeasurementsData['inseam'] = int.parse(val);
          },
          style: TextStyle(fontSize: 17.0),
        ),
        Text(
            'Measured from the crotch to desired finished distance from floor '),
        SizedBox(height: 30.0),
        TextFormField(
          decoration: customFormField('Crotch Depth'),
          controller: femaleCrotchDepth,
          keyboardType: TextInputType.number,
          validator: (value) => validateService.isEmptyField(value),
          onChanged: (String val) {
            bodyMeasurementsData['crotchDepth'] = int.parse(val);
          },
          style: TextStyle(fontSize: 17.0),
        ),
        Text('Measured seated, on the side, from seat to waist '),
        SizedBox(height: 30.0),
        ButtonTheme(
          minWidth: 180.0,
          child: FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(36),
                side: BorderSide(color: Colors.black)),
            padding: EdgeInsets.symmetric(vertical: 10.0),
            color: Colors.blue[800],
            textColor: Colors.white,
            child: Text(
              'Save',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              newM
                  ? bodyMeasurementsService.addFemale(bodyMeasurementsData)
                  : bodyMeasurementsService.updateFemale(
                      bodyMeasurementsData, docID);
              Navigator.pop(context);
            },
          ),
        )
      ],
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

  setBorder(double width, Color color) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(width: width, color: color));
  }
}
