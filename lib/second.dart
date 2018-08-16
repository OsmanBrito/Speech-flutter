import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  final String result;
  SecondScreen(this.result);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen"),
      ),
      body: Column(
        children: <Widget>[
          new TextFormField(
            initialValue: result,
          ),
          new RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(result),
          ),
        ],
      ),
    );
  }
}
