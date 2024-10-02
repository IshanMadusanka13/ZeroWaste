import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart'; // For opening the alert link

class NotificationListener extends StatefulWidget {
  @override
  _NotificationListenerState createState() => _NotificationListenerState();
}

class _NotificationListenerState extends State<NotificationListener> {
  final DatabaseReference _databaseRef =
  FirebaseDatabase.instance.ref('ZeroWaste');
  String? alertMessage;

  @override
  void initState() {
    super.initState();
    _setupListener();
  }

  void _setupListener() {
    _databaseRef.child('alert_message').onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null && data is String) {
        setState(() {
          alertMessage = data;
        });
      }
    });
  }

  // Function to launch the URL in the default browser
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Listener'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (alertMessage != null) ...[
            Card(
              elevation: 4,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.green, // Set card color to green
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alertMessage!,
                      style: const TextStyle(
                          fontSize: 18, color: Colors.white), // White text color
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Clear message on button click
                            setState(() {
                              alertMessage = null;
                            });
                          },
                          child: const Text('Dismiss'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Extract the link from the message and open it
                            final RegExp linkRegExp = RegExp(
                                r'Location:\s*(https?://[^\s]+)');
                            final match = linkRegExp.firstMatch(alertMessage!);
                            if (match != null) {
                              final alertLink = match.group(1);
                              if (alertLink != null) {
                                _launchURL(alertLink);
                              }
                            }
                          },
                          child: const Text('View'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ] else
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Waiting for alerts...",
                style: TextStyle(fontSize: 18),
              ),
            ),
        ],
      ),
    );
  }
}
