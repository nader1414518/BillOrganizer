import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:organizer/Models/Payment.dart';
import 'package:organizer/Screens/CamScreen.dart';
import 'package:organizer/Screens/new_payment.dart';
import 'package:organizer/Services/DBMan.dart';
import 'package:permission_handler/permission_handler.dart';

class PaymentScreen extends StatefulWidget {
  Payment payment;

  PaymentScreen({Key key, this.payment}) : super(key: key);

  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(widget.payment.paymentFor),
      ),
      body: ListView(
        children: [
          Padding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Amount: "),
                Text("${widget.payment.paymentAmount.toString()}   EGP"),
              ],
            ),
            padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 5.0),
          ),
          Padding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("For: "),
                Text("${widget.payment.paymentFor.toString()}"),
              ],
            ),
            padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          ),
          Padding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Date: "),
                Text("${widget.payment.paymentDate.toString()}"),
              ],
            ),
            padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          ),
          Padding(
            child: widget.payment.photo == null
                ? InkWell(
                    child: Card(
                      child: Container(
                        alignment: Alignment.center,
                        height: 100,
                        child: Text(
                          "No photo ... ",
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      margin: EdgeInsets.all(50.0),
                    ),
                    onTap: () async {
                      var res = await Permission.camera.isGranted;
                      if (!res) {
                        await Permission.camera.request();
                      }

                      var cameras = await availableCameras();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CamScreen(
                          payment: widget.payment,
                          camera: cameras[0],
                        );
                      }));
                    },
                  )
                : InkWell(
                    child: Image.file(
                      File(widget.payment.photo),
                    ),
                    onTap: () async {
                      var cameras = await availableCameras();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CamScreen(
                          payment: widget.payment,
                          camera: cameras[0],
                        );
                      }));
                    },
                  ),
            padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
          ),
        ],
      ),
      persistentFooterButtons: [
        IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              await DBMan().updatePayment(widget.payment);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Updated payment succesfully ... "),
                ),
              );
            })
      ],
    );
  }
}
