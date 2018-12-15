import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_reader/main.dart';
import 'package:simple_permissions/simple_permissions.dart';

void main() {
  runApp(new MyApp());  
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  String _reader = '';
  Permission permission = Permission.Camera;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();
  }

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: new AppBar(
          title: new Text(
            "Scanner"
          )
        ),
        body: Column(
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
            ),
            RaisedButton(
              splashColor: Colors.pinkAccent,
              color: Colors.red,
              child: new Text(
                "Scan", 
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,

                ),
                
              ),
              onPressed: scan,
            ),
            new Padding(
              padding: EdgeInsets.symmetric(
                vertical: 10.0
              ),
            ),
            Text(
              "$_reader",
              softWrap: true,
              style: new TextStyle(
                fontSize: 30.0,
                color: Colors.blue
              )
            )
          ],
        )
      )
    );
  }

  requestPermission() async {
    var result = await SimplePermissions.requestPermission(permission);
  }

  scan() async {
    try {
      String reader = await BarcodeScanner.scan();
      if(!mounted) {
        return;
      }   
      setState(() {
         _reader = reader;       
      });
    } on PlatformException catch(e) {
      if(e.code == BarcodeScanner.CameraAccessDenied) {
        requestPermission();
      } else {
        _reader = "unknown error $e";
      }
    }
  }

}

