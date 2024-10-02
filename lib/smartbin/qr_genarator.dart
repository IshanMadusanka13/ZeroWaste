import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrGenerate extends StatefulWidget {
  const QrGenerate({super.key});

  @override
  State<QrGenerate> createState() => _QrGenerateState();
}

class _QrGenerateState extends State<QrGenerate> {
  final GlobalKey globalKey = GlobalKey();
  String qrData = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Code generator"),
        backgroundColor: Colors.green.shade700,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
      backgroundColor: Colors.green,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50),
            RepaintBoundary(
              key: globalKey,
              child: Container(
                padding: EdgeInsets.all(16), // Optional: Add padding around QR code
                child: Center(
                  child: qrData.isEmpty
                      ? const Text(
                    "Enter Data To Generate QR Code",
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      : QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.05, // 10% border radius
                ),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Enter Location",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.1, // 10% border radius for the TextField border
                    ),
                    borderSide: BorderSide.none, // Removes the border outline of the TextField
                  ),
                  filled: true, // Enables the background color for the TextField
                  fillColor: Colors.white, // Ensures the background inside the TextField is white
                ),
                onChanged: (value) {
                  setState(() {
                    qrData = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
