import 'dart:async';
import 'dart:io';

import 'package:organizer/Models/Payment.dart';
import 'package:organizer/main.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBMan {
  Future<Database> getDatabase() async {
    var databasesPath = await getDatabasesPath();

    var database = await openDatabase(
      join(databasesPath, 'payments_v1.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE payment(id INTEGER PRIMARY KEY, amount DOUBLE, payment_for TEXT, payment_date TEXT, photo TEXT)',
        );
      },
      version: 1,
    );

    return database;
  }

  Future<void> addPayment(Payment payment) async {
    final db = await getDatabase();

    await db.insert(
      'payment',
      payment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Payment>> getPayments() async {
    final db = await getDatabase();

    final List<Map<String, dynamic>> maps = await db.query('payment');

    var payments = List.generate(
      maps.length,
      (index) {
        return Payment(
          id: maps[index]['id'],
          paymentAmount: maps[index]['amount'],
          paymentFor: maps[index]['payment_for'],
          paymentDate: maps[index]['payment_date'],
          photo: maps[index]['photo'],
        );
      },
    );

    return payments;
  }

  Future<void> updatePayment(Payment payment) async {
    final db = await getDatabase();

    await db.update(
      'payment',
      payment.toMap(),
      where: "id = ?",
      whereArgs: [payment.id],
    );
  }

  Future<void> deletePayment(int id) async {
    final db = await getDatabase();

    await db.delete(
      'payment',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deletePayments() async {
    final db = await getDatabase();

    await db.delete(
      'payment',
    );
  }
}
