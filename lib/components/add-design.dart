import 'dart:io';

import 'package:app_frontend/services/fileUploadService.dart';
import 'package:app_frontend/services/validateService.dart';
import 'package:app_frontend/services/designService.dart';
import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:image_picker/image_picker.dart';

class AddDesign extends StatefulWidget {
  @override
  _AddDesignState createState() => _AddDesignState();
}

class _AddDesignState extends State<AddDesign> {
  HashMap designData = new HashMap<String, dynamic>();
  ValidateService validateService = ValidateService();
  DesignService designService = DesignService();
  File _image;
  String fileLocation = '';

  FileUploadService fileUploadService = FileUploadService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          'Add design',
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
                TextFormField(
                  decoration: customFormField('Title'),
                  validator: (value) => validateService.isEmptyField(value),
                  onChanged: (String val) {
                    designData['title'] = val;
                  },
                  style: TextStyle(fontSize: 17.0),
                ),
                SizedBox(height: 30.0),
                TextFormField(
                  decoration: customFormField('Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) => validateService.isEmptyField(value),
                  onChanged: (String val) {
                    designData['price'] = int.parse(val);
                  },
                  style: TextStyle(fontSize: 17.0),
                ),
                SizedBox(height: 30.0),
                TextFormField(
                  decoration: customFormField('Time to deliver'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      validateService.validatePhoneNumber(value),
                  onChanged: (String val) {
                    designData['timeToDeliver'] = int.parse(val);
                  },
                  style: TextStyle(fontSize: 17.0),
                ),
                SizedBox(height: 30.0),
                TextFormField(
                  decoration: customFormField('Description'),
                  maxLines: 5,
                  keyboardType: TextInputType.text,
                  validator: (value) => validateService.validateEmail(value),
                  onChanged: (String val) {
                    designData['description'] = val;
                  },
                  style: TextStyle(fontSize: 17.0),
                ),
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
                      'Select image',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ),
                _image != null ? Image.file(_image) : Container(),
                SizedBox(height: 50.0),
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
                      'Add',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      designService.add(
                          designData['title'],
                          designData['price'],
                          designData['timeToDeliver'],
                          designData['description'],
                           _image != null ? "https://firebasestorage.googleapis.com/v0/b/darzi-3f31a.appspot.com/o/$fileLocation?alt=media" : '');
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            )),
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

  setBorder(double width, Color color) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(width: width, color: color));
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
}
