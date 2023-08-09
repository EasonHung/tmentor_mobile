import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

class PayScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return PayScreenState();
  }

}

class PayScreenState extends State<PayScreen> {
  final paymentItems1 = [
    PaymentItem(
      label: "Total",
      amount: "99",
      status: PaymentItemStatus.final_price
    )
  ];

  final paymentItems2 = [
    PaymentItem(
        label: "Total",
        amount: "399",
        status: PaymentItemStatus.final_price
    )
  ];

  void onGooglePayResult1(paymentResult) {
    print("99 points");
    debugPrint(paymentResult.toString());
  }

  void onGooglePayResult2(paymentResult) {
    print("399 points");
    debugPrint(paymentResult.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
           GooglePayButton(
              paymentConfigurationAsset: 'gpay.json',
              paymentItems: paymentItems1,
              type: GooglePayButtonType.pay,
              margin: const EdgeInsets.only(top: 15.0),
              onPaymentResult: onGooglePayResult1,
              loadingIndicator: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            GooglePayButton(
              paymentConfigurationAsset: 'gpay.json',
              paymentItems: paymentItems2,
              type: GooglePayButtonType.pay,
              margin: const EdgeInsets.only(top: 15.0),
              onPaymentResult: onGooglePayResult2,
              loadingIndicator: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ]
        )
      )
    );
  }
  
}