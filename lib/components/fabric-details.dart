import 'package:flutter/material.dart';

class FabricDetails extends StatefulWidget {
  String title;
  int price;
  String description;
  String image;

  FabricDetails(
      {this.title,
      this.price,
      this.description,
      this.image});

  @override
  _FabricDetailsState createState() => _FabricDetailsState();
}

class _FabricDetailsState extends State<FabricDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            key: Key("BackButton"),
          ),
          backgroundColor: Colors.black,
        ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.width / 2.2,
                floating: false,
                leading: Container(),
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    background: Image.network(
                      widget.image == null || widget.image == ''
                          ? "https://images-na.ssl-images-amazon.com/images/I/614Qz2LAnJL._UL1500_.jpg"
                          : widget.image,
                      fit: BoxFit.contain,
                    )),
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.only(left: 2.0, right: 2.0),
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title,
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w500)),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text("Price: ${widget.price}",
                          style: TextStyle(
                            fontSize: 16.0,
                          )),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(widget.description,
                          style: TextStyle(
                            fontSize: 16.0,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
