import 'package:flutter/material.dart';

class DesignItem extends StatefulWidget {
  String title;
  int price;
  int timeToDeliver;
  String description;
  String image;

  DesignItem(
      {this.title,
      this.price,
      this.timeToDeliver,
      this.description,
      this.image});
  @override
  _DesignItemState createState() => _DesignItemState();
}

class _DesignItemState extends State<DesignItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Stack(
          children: [
            Center(
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/loading.gif',
                image: widget.image == null || widget.image == ''
                    ? "https://images-na.ssl-images-amazon.com/images/I/614Qz2LAnJL._UL1500_.jpg"
                    : widget.image,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                Expanded(
                  flex: 5,
                  child: Container(),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    width: double.infinity,
                    color: Colors.black.withOpacity(0.4),
                    margin: EdgeInsets.only(bottom: 0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        margin: EdgeInsets.all(10),
      ),
    );
  }
}
