import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:up_panammun/screens/signin.dart';

class WebInfo extends StatefulWidget {
  @override
  _WebInfo createState() => _WebInfo();
}
class _WebInfo extends State<WebInfo> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
  }
  Completer<WebViewController> _controller = Completer<WebViewController>();
  bool isLoading=false;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        leading:  IconButton(
          icon: Icon(Icons.arrow_left_outlined),
          color: Colors.white,
          iconSize: MediaQuery.of(context).size.width*0.12,
          onPressed: () {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new SignIn(),
              ),
            );
          },
        ),
        title: Text(
          "UP Panammun 2022",
          textAlign: TextAlign.right,
          style: GoogleFonts.prata(
              textStyle: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04, letterSpacing: 1)),
        ),
        backgroundColor: Color(0xFF023859),
        centerTitle: true,
        actions: <Widget>[

        ],
      ),
      body: Stack(
        children: [
          WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: 'https://sites.google.com/up.edu.mx/panammun/inicio?authuser=0',
            onPageFinished:(value){
              setState(() {
                isLoading=true;
              });

            },

          ),
          (!isLoading)?Center(
            child: CircularProgressIndicator(
              backgroundColor: Color(0xFF3B52D9),
            ),
          ):Container()
        ],

      ),
    );
  }

}

