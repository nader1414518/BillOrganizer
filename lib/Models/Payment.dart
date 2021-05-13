class Payment {
  int id;
  double paymentAmount;
  String paymentFor;
  String paymentDate;
  String photo;

  Payment(
      {this.id,
      this.paymentAmount,
      this.paymentFor,
      this.paymentDate,
      this.photo});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': paymentAmount,
      'payment_for': paymentFor,
      'payment_date': paymentDate,
      'photo': photo
    };
  }
}
