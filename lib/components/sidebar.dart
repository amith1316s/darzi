import 'dart:io';

import 'package:app_frontend/components/orders/orderHistory.dart';
import 'package:app_frontend/pages/body-measurements/body-measurements.dart';
import 'package:app_frontend/services/file_handler_service.dart';
import 'package:app_frontend/services/orderService.dart';
import 'package:app_frontend/services/report_generate_service.dart';
import 'package:flutter/material.dart';

import 'package:app_frontend/components/add-design.dart';
import 'package:app_frontend/components/add-fabric.dart';
import 'package:app_frontend/components/add-seller.dart';
import 'package:app_frontend/services/userService.dart';

Widget sidebar(BuildContext context, String role) {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  UserService _userService = new UserService();
  ReportGenerateService _reportGenerateService = new ReportGenerateService();
  FileHandlerService _filehandlerservice = new FileHandlerService();
  OrderService orderService = OrderService();

  return SafeArea(
    child: Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ListView(
            shrinkWrap: true,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.home),
                title: Text(
                  'HOME',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0),
                ),
                onTap: () {
                  print(role);
                  Navigator.popAndPushNamed(context, '/home');
                },
              ),
              role == 'seller'
                  ? ListTile(
                      leading: ImageIcon(AssetImage("assets/design.png")),
                      title: Text(
                        'Add Design',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0),
                      ),
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddDesign()));
                      },
                    )
                  : Container(),
              role == 'seller'
                  ? ListTile(
                      leading: ImageIcon(AssetImage("assets/fabric.png")),
                      title: Text(
                        'Add Fabric',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0),
                      ),
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddFabric()));
                      },
                    )
                  : Container(),
              role == 'admin'
                  ? ListTile(
                      leading: ImageIcon(AssetImage("assets/design.png")),
                      title: Text(
                        'Add Tayler',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0),
                      ),
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddSeller()));
                      },
                    )
                  : Container(),
              role == 'user'
                  ? ListTile(
                      leading: ImageIcon(AssetImage("assets/fabric.png")),
                      title: Text(
                        'Body measurements',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0),
                      ),
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BodyMeasurements()));
                      },
                    )
                  : Container(),
              ListTile(
                leading: Icon(Icons.local_shipping),
                title: Text(
                  'Orders',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0),
                ),
                onTap: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderHistory(role: role)));
                },
              ),
              role == 'admin' || role == 'seller'
                  ? ListTile(
                      leading: Icon(Icons.receipt),
                      title: Text(
                        'Reports',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0),
                      ),
                      onTap: () async {
                        var dir = await _filehandlerservice.downloadPath;
                        var fileName = "report${DateTime.now()}";
                        File shareFile = File("$dir/$fileName.pdf");

                        var data;
                        if (role == 'user') {
                          data = await orderService.orderListForUser();
                        } else if (role == 'seller') {
                          data = await orderService.orderListForSeller();
                        } else if (role == 'admin') {
                          data = await orderService.orderListForAdmin();
                        }
                        var htmlContent = await _reportGenerateService
                            .generateReportContent(data);

                        await _filehandlerservice.generatePDFDocument(
                            "$fileName", htmlContent, context);

                        _okayDialog(context);
                        // _filehandlerservice.shareFile(
                        //     "report", "Share Report", "Share report");
                      },
                    )
                  : Container(),
              ListTile(
                leading: new Icon(Icons.exit_to_app),
                title: Text(
                  'logout',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0),
                ),
                onTap: () {
                  _userService.logOut(context);
                },
              )
            ],
          )
        ],
      ),
    ),
  );
}

Future<void> _okayDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Report'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Your report is saved on download folder.'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('ok'),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
