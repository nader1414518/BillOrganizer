import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:organizer/Models/Payment.dart';
import 'package:organizer/Screens/payment_screen.dart';

class CamScreen extends StatefulWidget {
  Payment payment;
  CameraDescription camera;

  CamScreen({Key key, this.payment, this.camera}) : super(key: key);

  CamScreenState createState() => CamScreenState();
}

class CamScreenState extends State<CamScreen> {
  CameraController controller;

  @override
  void initState() {
    super.initState();

    controller = CameraController(widget.camera, ResolutionPreset.medium);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text("Take a photo"),
      ),
      body: FutureBuilder<void>(
        future: controller.initialize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(controller);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async {
          try {
            await controller.initialize();

            final image = await controller.takePicture();

            widget.payment.photo = image.path;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return PaymentScreen(
                    payment: widget.payment,
                  );
                },
              ),
            );
          } catch (ex) {
            print(ex.toString());
          }
        },
      ),
    );
  }
}
