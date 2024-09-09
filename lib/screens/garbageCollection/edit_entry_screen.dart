import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zero_waste/models/garbage_entry.dart';
import 'package:zero_waste/repositories/garbage_entry_repository.dart';
import 'package:zero_waste/widgets/submit_button.dart';

class EditEntryScreen extends StatefulWidget {
  final GarbageEntry entry;

  const EditEntryScreen({super.key, required this.entry});

  @override
  _EditEntryScreenState createState() => _EditEntryScreenState();
}

class _EditEntryScreenState extends State<EditEntryScreen> {
  late TextEditingController plasticController;
  late TextEditingController glassController;
  late TextEditingController paperController;
  late TextEditingController organicController;
  late TextEditingController metalController;
  late TextEditingController ewasteController;

  @override
  void initState() {
    super.initState();
    plasticController =
        TextEditingController(text: widget.entry.plasticWeight.toString());
    glassController =
        TextEditingController(text: widget.entry.glassWeight.toString());
    paperController =
        TextEditingController(text: widget.entry.paperWeight.toString());
    organicController =
        TextEditingController(text: widget.entry.organicWeight.toString());
    metalController =
        TextEditingController(text: widget.entry.metelWeight.toString());
    ewasteController =
        TextEditingController(text: widget.entry.eWasteWeight.toString());
  }

  @override
  void dispose() {
    plasticController.dispose();
    glassController.dispose();
    paperController.dispose();
    organicController.dispose();
    metalController.dispose();
    ewasteController.dispose();
    super.dispose();
  }

  void _updateEntry(BuildContext context) {
    double plasticWeight = double.tryParse(plasticController.text) ?? -1;
    double glassWeight = double.tryParse(glassController.text) ?? -1;
    double paperWeight = double.tryParse(paperController.text) ?? -1;
    double organicWeight = double.tryParse(organicController.text) ?? -1;
    double metalWeight = double.tryParse(metalController.text) ?? -1;
    double ewasteWeight = double.tryParse(ewasteController.text) ?? -1;

    if (plasticWeight < 0 ||
        glassWeight < 0 ||
        paperWeight < 0 ||
        organicWeight < 0 ||
        metalWeight < 0 ||
        ewasteWeight < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter non-negative values for all weights.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final garbageEntry = GarbageEntry(
        userId: widget.entry.userId,
        plasticWeight: plasticWeight,
        glassWeight: glassWeight,
        paperWeight: paperWeight,
        organicWeight: organicWeight,
        metelWeight: metalWeight,
        eWasteWeight: ewasteWeight,
        date: widget.entry.date);

    GarbageEntryRepository()
        .updateEntry(widget.entry.id, garbageEntry)
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Entry updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        context.go("/collection/history");
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update entry: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Entry'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildWasteCard(
                  'Plastic Weight', plasticController, Icons.local_drink),
              _buildWasteCard('Glass Weight', glassController, Icons.wine_bar),
              _buildWasteCard('Paper Weight', paperController, Icons.article),
              _buildWasteCard('Organic Weight', organicController, Icons.grass),
              _buildWasteCard(
                  'Metal Weight', metalController, Icons.home_repair_service),
              _buildWasteCard('E-Waste Weight', ewasteController, Icons.memory),
              const SizedBox(height: 20),
              SubmitButton(
                  icon: Icons.send,
                  text: "Save",
                  whenPressed: _updateEntry),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWasteCard(
      String label, TextEditingController controller, IconData icon) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Colors.green.shade600),
            const SizedBox(width: 15),
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: TextStyle(color: Colors.grey.shade700),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.green.shade600, width: 2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
