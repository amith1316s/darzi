import 'dart:async';
import 'dart:io';

import 'package:app_frontend/components/add-design.dart';
import 'package:app_frontend/components/add-fabric.dart';
import 'package:app_frontend/components/add-seller.dart';
import 'package:app_frontend/components/fabric-details.dart';
import 'package:app_frontend/components/feedbacks.dart';
import 'package:app_frontend/components/orders/add-order.dart';
import 'package:app_frontend/components/orders/orderHistory.dart';
import 'package:app_frontend/services/file_handler_service.dart';
import 'package:app_frontend/services/orderService.dart';
import 'package:app_frontend/services/report_generate_service.dart';
import 'package:app_frontend/services/userService.dart';
import 'package:flutter/material.dart';
import 'package:app_frontend/components/header.dart';
import 'package:app_frontend/components/design-details.dart';
import 'package:app_frontend/components/design-item.dart';
import 'package:app_frontend/components/sidebar.dart';
import 'package:flutter/services.dart';
import 'package:app_frontend/services/designService.dart';
import 'package:app_frontend/services/fabricService.dart';
import 'package:flutter_awesome_buttons/flutter_awesome_buttons.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DesignService designService = DesignService();
  FabricService fabricService = FabricService();
  UserService userService = UserService();
  ReportGenerateService _reportGenerateService = new ReportGenerateService();
  FileHandlerService _filehandlerservice = new FileHandlerService();
  OrderService orderService = OrderService();
  List designList = [];
  List fabricList = [];

  String selectedDesignID = '';
  String selectedFabricID = '';

  dynamic selectedDesign;
  dynamic selectedFabric;

  String role;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    role = await userService.getRole();
    var res = await designService.designList();
    setState(() {
      designList = res;
      if (designList.length > 0) {
        selectedDesignID = designList[0].documentID;
        selectedDesign = designList[0].data;
      }
    });

    var res2 = await fabricService.fabricList();
    setState(() {
      fabricList = res2;
      if (fabricList.length > 0) {
        selectedFabricID = fabricList[0].documentID;
        selectedFabric = fabricList[0].data;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    bool showCartIcon = true;
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return WillPopScope(
      onWillPop: () async {
        return (await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0)),
                      title: Text('Are you sure ?'),
                      content: Text('Do you want to exit an App'),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('No',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                        FlatButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('Yes',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red)),
                        )
                      ],
                    ))) ??
            false;
      },
      child: Scaffold(
          key: _scaffoldKey,
          appBar: header('Darzi', _scaffoldKey, showCartIcon, context),
          drawer: sidebar(context, role),
          floatingActionButton: role == 'user'
              ? FloatingActionButton(
                  backgroundColor: Colors.white,
                  child: Column(
                    children: [
                      Icon(
                        Icons.shopping_basket,
                        color: Colors.blueAccent,
                      ),
                      Text(
                        'Continue Order',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: Colors.blueAccent, fontSize: 10),
                      )
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddOrder(
                                fabric: selectedFabric,
                                design: selectedDesign)));
                  },
                )
              : FloatingActionButton(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.refresh,
                    color: Colors.blueAccent,
                  ),
                  onPressed: () {
                    getData();
                  },
                ),
          body: Container(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    role == 'seller'
                        ? Padding(
                            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Card(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Colors.lightBlue,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: ListTile(
                                            leading: ImageIcon(AssetImage(
                                                "assets/design.png")),
                                            title: Text(
                                              'Add Design',
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.0),
                                            ),
                                            onTap: () async {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddDesign()));
                                            },
                                          ))
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Card(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Colors.lightBlue,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: ListTile(
                                            leading: ImageIcon(AssetImage(
                                                "assets/fabric.png")),
                                            title: Text(
                                              'Add Fabric',
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.0),
                                            ),
                                            onTap: () async {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddFabric()));
                                            },
                                          ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container(),
                    role == 'admin' || role == 'seller'
                        ? Padding(
                            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Card(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.lightBlue,
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: ListTile(
                                            leading: Icon(Icons.receipt),
                                            title: Text(
                                              'Reports',
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.0),
                                            ),
                                            onTap: () async {
                                              if (await Permission.storage
                                                  .request()
                                                  .isGranted) {
                                                var dir =
                                                    await _filehandlerservice
                                                        .downloadPath;
                                                var fileName =
                                                    "report${DateTime.now().toString()}";
                                                File shareFile =
                                                    File("$dir/$fileName.pdf");

                                                var data;
                                                if (role == 'user') {
                                                  data = await orderService
                                                      .orderListForUser();
                                                } else if (role == 'seller') {
                                                  data = await orderService
                                                      .orderListForSeller();
                                                } else if (role == 'admin') {
                                                  data = await orderService
                                                      .orderListForAdmin();
                                                }
                                                var htmlContent =
                                                    await _reportGenerateService
                                                        .generateReportContent(
                                                            data);

                                                await _filehandlerservice
                                                    .generatePDFDocument(
                                                        "$fileName",
                                                        htmlContent,
                                                        context);

                                                _okayDialog();

                                                // _filehandlerservice.shareFile(
                                                //     "report",
                                                //     "Share Report",
                                                //     "Share report");
                                              }
                                            }),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Card(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.lightBlue,
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: ListTile(
                                          leading: Icon(Icons.local_shipping),
                                          title: Text(
                                            'Orders',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1.0),
                                          ),
                                          onTap: () async {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        OrderHistory(
                                                            role: role)));
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container(),
                    role == 'admin'
                        ? Padding(
                            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Card(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Colors.lightBlue,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: ListTile(
                                            leading: ImageIcon(AssetImage(
                                                "assets/design.png")),
                                            title: Text(
                                              'Add Tayler',
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.0),
                                            ),
                                            onTap: () async {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddSeller()));
                                            },
                                          ))
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    role == 'seller'
                        ? Padding(
                            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Card(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Colors.lightBlue,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: ListTile(
                                            leading: Icon(Icons.list),
                                            title: Text(
                                              'Feedbakcs',
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.0),
                                            ),
                                            onTap: () async {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Feedbacks()));
                                            },
                                          ))
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(),
                                )
                              ],
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                      child: Text(
                        'Fabrics',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            fontFamily: 'NovaSquare'),
                      ),
                    ),
                    Container(height: 100.0, child: getFabricList()),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                      child: Text(
                        'Designs',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            fontFamily: 'NovaSquare'),
                      ),
                    ),
                    Container(
                        height: 420.0,
                        child: ListView.builder(
                          itemCount: designList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DesignDetails(
                                              title: designList[index]
                                                  .data['title'],
                                              timeToDeliver: designList[index]
                                                  .data['timeToDeliver'],
                                              price: designList[index]
                                                  .data['price'],
                                              description: designList[index]
                                                  .data['description'],
                                              image: designList[index]
                                                  .data['image'])));
                                },
                                child: Stack(
                                  children: [
                                    DesignItem(
                                      title: designList[index].data['title'],
                                      timeToDeliver: designList[index]
                                          .data['timeToDeliver'],
                                      price: designList[index].data['price'],
                                      description:
                                          designList[index].data['description'],
                                      image: designList[index].data['image'],
                                    ),
                                    Checkbox(
                                      checkColor: Colors.white,
                                      activeColor: Colors.blueAccent,
                                      value: selectedDesignID ==
                                          designList[index].documentID,
                                      onChanged: (bool value) {
                                        setState(() {
                                          selectedDesignID =
                                              designList[index].documentID;
                                          selectedDesign =
                                              designList[index].data;
                                        });
                                      },
                                    ),
                                  ],
                                ));
                          },
                        )),
                  ]),
                ),
              ],
            ),
          )),
    );
  }

  Future<void> _okayDialog() async {
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
                SizedBox(height: 15),
                Text(
                  ' If cannot find it directly go to files => internal storage => downloads',
                  style: TextStyle(color: Colors.blueAccent, fontSize: 13),
                ),
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

  getFabricList() {
    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: fabricList.length,
        itemBuilder: (context, index) {
          var item = fabricList[index];
          return Container(
            width: 200.0,
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FabricDetails(
                                title: fabricList[index].data['title'],
                                price: fabricList[index].data['price'],
                                description:
                                    fabricList[index].data['description'],
                                image: fabricList[index].data['image'])));
                  },
                  child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            image: DecorationImage(
                                image: NetworkImage(item.data['image'] ==
                                            null ||
                                        item.data['image'] == ''
                                    ? "https://cdn.shopify.com/s/files/1/0558/3725/products/Light_Blue_Twill_Fabric_1000x.jpg?v=1571438674"
                                    : item.data['image']),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Color.fromRGBO(90, 90, 90, 0.8),
                                    BlendMode.modulate))),
                        child: Center(
                          child: Text(
                            item.data['title'],
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20.0,
                                color: Colors.white,
                                letterSpacing: 1.0,
                                fontFamily: 'NovaSquare'),
                          ),
                        ),
                      )),
                ),
                Checkbox(
                  checkColor: Colors.white,
                  activeColor: Colors.blueAccent,
                  value: selectedFabricID == fabricList[index].documentID,
                  onChanged: (bool value) {
                    setState(() {
                      selectedFabricID = fabricList[index].documentID;
                      selectedFabric = fabricList[index].data;
                    });
                  },
                ),
              ],
            ),
          );
        });
  }
}
