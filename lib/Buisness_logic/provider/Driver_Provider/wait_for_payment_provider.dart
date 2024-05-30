import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WaitForPaymentProvider extends ChangeNotifier {
  String tripId = "";
  String payment_method = "";
  String payment_status = ""; // for e_payment
  bool is_loading = false;
  Map<String, dynamic> tripData = {};

  setData(Map<String, dynamic> data) {
    tripData = data;
    tripId = data["trip_id"] ?? tripId;
    payment_method = data["payment_method"] ?? payment_method;
    payment_status = data["payment_status"] ?? payment_status;
    print("======================================");
    print(tripData);
    print(tripId);
    print(payment_method);
    print(payment_status);
    print("======================================");
    notifyListeners();
  }

  reset() {
    tripId = "";
    payment_method = "";
    payment_status = "";
    is_loading = false;
  }

  Widget cashBuilder() {
    return Column(
      children: [
        Text(tripData["message"] ?? ""),
        Text("المستخدم قرر الدفع عن طريق الكاش"),
        Text("استلم منه النقود ثم انقر تم الاستلام"),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }

  Widget ePaymentBuilder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(tripData["message"] ?? ""),
        Text("المستخدم قرر الدفع عن طريق بوابة الدفع"),
        Text("انتظر لعندما تتم عملية التحويل"),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }
}
