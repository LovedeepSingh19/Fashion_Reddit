import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LeftPart extends StatefulWidget {
  LeftPart({Key? key}) : super(key: key);

  @override
  _LeftPartState createState() => _LeftPartState();
}

class _LeftPartState extends State<LeftPart> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          height: 100,
        ),
        Text(
          "followers",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 20,
        ),
        Divider(
          color: Colors.black,
        ),
        Text("following", style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          height: 20,
        ),
        Divider(
          color: Colors.black,
        ),
      ],
    );
  }
}
