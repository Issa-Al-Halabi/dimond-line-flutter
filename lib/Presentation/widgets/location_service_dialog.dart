import 'package:diamond_line/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

Future LocationServiceDialog(
    BuildContext context, {
      required Function() onRetry,
      required Function() onClose,
      required String title,
    }) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                // getTranslated(context, "please_enable_your_location_service_and_try_again",)!,
                title,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
        actions: <Widget>[
          Center(
            child: MaterialButton(
                color: primaryBlue,
                textColor: Colors.white,
                child: Text("retry".tr()),
                onPressed: () async {
                  Navigator.pop(context);
                  await onRetry();
                }),
          ),
        ],
      );
    },
  ).then((value) {
    if (onClose != null) onClose();
  });
}