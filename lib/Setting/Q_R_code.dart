


  import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCode extends StatefulWidget {
  const QRCode({super.key});

  @override
  State<QRCode> createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('QR Code'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(children: [
            Card(
              child: SingleChildScrollView(
                child: Padding(
                  padding:const EdgeInsets.all(30),
                  child: Card(
                    color: Colors.white,
                    child: QrImageView( 
                      data: '01154830689  & 01281828333      كلمني واتس هنا وريح دماغك علشان ان كدا كدا مش هرفعه عل   app store',
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
