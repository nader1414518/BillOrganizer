import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:organizer/Models/Payment.dart';
import 'package:organizer/Screens/new_payment.dart';
import 'package:organizer/Screens/payment_screen.dart';
import 'package:organizer/Services/DBMan.dart';
import 'package:organizer/widgets/NavDrawer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Organizer',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  static List<Payment> payments = [];

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    DBMan().getPayments().then((value) {
      setState(() {
        MyHomePage.payments = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: true,
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.picture_as_pdf),
              onPressed: () async {
                if (MyHomePage.payments != []) {
                  final pdf = pw.Document();

                  for (var payment in MyHomePage.payments) {
                    pw.MemoryImage image;
                    try {
                      image = pw.MemoryImage(
                        File(payment.photo).readAsBytesSync(),
                      );
                    } catch (ex) {
                      image = null;
                    }

                    pdf.addPage(
                      pw.MultiPage(
                        pageFormat: PdfPageFormat.a4,
                        build: (pw.Context context) {
                          return [
                            pw.Padding(
                              padding:
                                  pw.EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 5.0),
                              child: pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Text("Payment Amount: "),
                                  pw.Text(
                                    "${payment.paymentAmount.toString()}",
                                    style: pw.TextStyle(
                                      fontSize: 18,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            pw.Padding(
                              padding:
                                  pw.EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
                              child: pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Text("For: "),
                                  pw.Text(
                                    "${payment.paymentFor.toString()}",
                                    style: pw.TextStyle(
                                      fontSize: 18,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            pw.Padding(
                              padding:
                                  pw.EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
                              child: pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Text("Date: "),
                                  pw.Text(
                                    "${payment.paymentDate.toString()}",
                                    style: pw.TextStyle(
                                      fontSize: 18,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            pw.Padding(
                              padding:
                                  pw.EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
                              child: image == null
                                  ? pw.Text("No Image ... ")
                                  : pw.Image(image),
                            ),
                          ];
                        },
                      ),
                    );
                  }

                  var bytes = await pdf.save();
                  if (bytes != null) {
                    var res = await Permission.storage.request();
                    if (res.isGranted) {
                      var appPath = await getExternalStorageDirectory();
                      print("${appPath.path}/Bill_Report.pdf");
                      final file = File("${appPath.path}/Bill_Report.pdf");
                      if (file != null) {
                        await file.writeAsBytes(bytes);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text("PDF Report Generated Successfully ... "),
                          ),
                        );

                        if (Platform.isAndroid) {
                          OpenFile.open(file.path);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Permissions to write are not granted ... "),
                          ),
                        );
                      }
                    }
                  }
                }
              })
        ],
      ),
      drawer: NavDrawer(),
      body: ListView.builder(
          itemCount: MyHomePage.payments.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${MyHomePage.payments[index].id}"),
                    Text("${MyHomePage.payments[index].paymentFor}"),
                    Text("${MyHomePage.payments[index].paymentAmount}"),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        if (MyHomePage.payments.length == 1) {
                          await DBMan().deletePayments();
                          setState(() {
                            MyHomePage.payments = [];
                          });
                        } else {
                          await DBMan().deletePayment(index);
                          DBMan().getPayments().then((value) {
                            setState(() {
                              MyHomePage.payments = value;
                            });
                          });
                        }
                      },
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PaymentScreen(
                      payment: MyHomePage.payments[index],
                    );
                  }));
                },
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return NewPaymentScreen();
          }));
        },
        tooltip: 'Add new payment',
        child: Icon(Icons.add),
      ),
    );
  }
}
