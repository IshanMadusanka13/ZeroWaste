import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class QRScanPage extends StatelessWidget {
  const QRScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
      body: Container(
        color: Colors.green, // Set the background color to green
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Scan the QR Code',
                style: TextStyle(
                  fontSize: 24, // Title size
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Text color
                ),
              ),
            ),
            Expanded(
              child: const QRViewExample(),
            ),
          ],
        ),
      ),
    );
  }
}

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? lastScannedData; // Variable to keep track of the last scanned data

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.green.shade700,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: 250,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      // Check if the scanned data is the same as the last one
      if (scanData.code != lastScannedData) {
        lastScannedData = scanData.code; // Update the last scanned data
        print('Scanned Data: ${scanData.code}');
        _showTopUpDialog(scanData.code); // Show the top-up dialog
      }
    });
  }

  void _showTopUpDialog(String? scannedData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Send Message"),
          content: const Text("Send the message to all users?"),
          actions: [
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                _sendMessageToUsers(scannedData);
                Navigator.of(context).pop(); // Close the dialog
                _showAwesomeMessage(); // Show awesome message after sending
              },
            ),
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendMessageToUsers(String? url) async {
    // Reference your Firestore collection where user data is stored
    final usersCollection = FirebaseFirestore.instance.collection('users');

    // Fetch all users
    final querySnapshot = await usersCollection.get();

    // Prepare the message
    String message = 'Smart bin clear: $url';

    // Send message to all users (you can customize this part)
    for (var doc in querySnapshot.docs) {
      String userId = doc.id; // Assuming each document ID is a user ID
      // Implement your logic to send a message or notification
      // For example, you might use Firebase Cloud Messaging (FCM) to send notifications
      // Or you can store the messages in the Firestore as needed
      print('Sending message to $userId: $message'); // Replace with actual sending logic
    }

    // Notify the user that the message has been sent
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message sent to all users.')),
    );
  }

  void _showAwesomeMessage() {
    // Show an awesome message to all app users
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Awesome! Message sent to all users!')),
    );
  }
}
