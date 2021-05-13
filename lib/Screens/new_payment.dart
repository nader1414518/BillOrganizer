import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:organizer/Models/Payment.dart';
import 'package:organizer/Services/DBMan.dart';
import 'package:organizer/main.dart';

class NewPaymentScreen extends StatefulWidget {
  NewPaymentScreenState createState() => NewPaymentScreenState();
}

class NewPaymentScreenState extends State<NewPaymentScreen> {
  TextEditingController paymentAmountController = TextEditingController();
  TextEditingController paymentForController = TextEditingController();

  final DBMan dbMan = DBMan();

  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Payment"),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: ListView(
        children: [
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 10.0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Payment amount: ",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter value (EGP) ... ",
                    ),
                    keyboardType: TextInputType.number,
                    controller: paymentAmountController,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Payment for: ",
                  style: TextStyle(fontSize: 16.2, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter value ... ",
                    ),
                    keyboardType: TextInputType.text,
                    controller: paymentForController,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        backgroundColor: Colors.deepOrange,
        onPressed: () async {
          if (dbMan != null) {
            var payments = await dbMan.getPayments();
            if (payments != null) {
              var count = payments.length;

              if (paymentAmountController.text.isEmpty ||
                  paymentForController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Some fields are empty .. "),
                  ),
                );
              } else {
                Payment payment = Payment(
                  paymentAmount: double.parse(paymentAmountController.text),
                  paymentFor: paymentForController.text,
                  paymentDate: DateTime.now().toString(),
                  id: count,
                );

                await dbMan.addPayment(payment);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Add payment to list ... "),
                  ),
                );

                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return MyHomePage(
                    title: "Home",
                  );
                }));
              }
            }
          }
        },
      ),
    );
  }
}
