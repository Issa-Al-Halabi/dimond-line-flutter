import 'package:diamond_line/Presentation/widgets/text.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/loader_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../../constants.dart';

class WebViewScreen extends StatefulWidget {
  WebViewScreen({required this.url, Key? key}) : super(key: key);
  String url;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final _key = UniqueKey();
  String res = '';

  @override
  Widget build(BuildContext context) {
    print(widget.url);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Builder(builder: (BuildContext context) {
          return InkWell(
            onTap: () async {
              Navigator.of(context).pop();
            },
            child: Container(
              child: Center(
                child: Icon(
                  Icons.keyboard_arrow_left,
                  size: 32,
                  color: primaryBlue,
                ),
              ),
            ),
          );
        }),
        // leadingWidth: 3.w,
        centerTitle: true,
        title: Center(
          child: Text(
            AppName,
            style: TextStyle(
              fontSize: 7.sp,
              color: primaryBlue,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: WebView(
            key: _key,
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: widget.url,
            navigationDelegate: (request) async {
              res = request.url;
              print('request.url' + request.url);
              return NavigationDecision.navigate;
            },
            onPageFinished: (String url) {
              setState(() {});
              res = url;
              print("url " + res);
              print('Page finished loading: $url');
            },
          ))
        ],
      ),
    );
  }
}