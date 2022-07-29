import 'package:flutter/material.dart';

import '../../../constants.dart';

class ChatAndAddToCart extends StatelessWidget {
  const ChatAndAddToCart({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(kDefaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFFCBF1E),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: <Widget>[

          FlatButton.icon(
            onPressed: () {},
            icon:  Icon(Icons.auto_awesome_rounded , color: Colors.green),
            label: Text(
              "Make Appointment",
              style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
