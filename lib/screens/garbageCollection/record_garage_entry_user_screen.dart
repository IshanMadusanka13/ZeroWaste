import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zero_waste/models/garbage_entry.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:zero_waste/repositories/garbage_entry_repository.dart';
import 'package:zero_waste/utils/validators.dart';
import 'package:zero_waste/widgets/submit_button.dart';
import 'package:zero_waste/widgets/text_field_input.dart';

class RecordGarbageEntryScreen extends StatefulWidget {
  const RecordGarbageEntryScreen({super.key});

  @override
  _RecordGarbageEntryScreenState createState() =>
      _RecordGarbageEntryScreenState();
}

class _RecordGarbageEntryScreenState extends State<RecordGarbageEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userId = TextEditingController();
  final _plasticWeight = TextEditingController();
  final _glassWeight = TextEditingController();
  final _paperWeight = TextEditingController();
  final _organicWeight = TextEditingController();
  final _metelWeight = TextEditingController();
  final _eWasteWeight = TextEditingController();

  void _submitEntry(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if ((double.tryParse(_plasticWeight.text) ?? 0) +
              (double.tryParse(_glassWeight.text) ?? 0) +
              (double.tryParse(_paperWeight.text) ?? 0) +
              (double.tryParse(_organicWeight.text) ?? 0) +
              (double.tryParse(_metelWeight.text) ?? 0) +
              (double.tryParse(_eWasteWeight.text) ?? 0) ==
          0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please enter at least one waste weight')),
        );
        return;
      }

      GarbageEntry entry = GarbageEntry(
        userId: _userId.text,
        plasticWeight: double.tryParse(_plasticWeight.text) ?? 0.0,
        glassWeight: double.tryParse(_glassWeight.text) ?? 0.0,
        paperWeight: double.tryParse(_paperWeight.text) ?? 0.0,
        organicWeight: double.tryParse(_organicWeight.text) ?? 0.0,
        metelWeight: double.tryParse(_metelWeight.text) ?? 0.0,
        eWasteWeight: double.tryParse(_eWasteWeight.text) ?? 0.0,
        date: DateTime.now(),
      );

      await GarbageEntryRepository().addEntry(entry);

      await _generateAndDownloadPDF(entry);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Garbage entry recorded and PDF downloaded!'),
        backgroundColor: Colors.green,
      ));
    }
  }

  Future<void> _generateAndDownloadPDF(GarbageEntry entry) async {
    final pdf = pw.Document();

    final ByteData logoData = await rootBundle.load('assets/logo.png');
    final Uint8List logoBytes = logoData.buffer.asUint8List();

    pw.TableRow buildTableRow(String label, String value) {
      return pw.TableRow(
        children: [
          pw.Padding(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.green800,
              ),
            ),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.all(8),
            child: pw.Text(value),
          ),
        ],
      );
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header Section
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: const pw.BoxDecoration(
                  color: PdfColors.green50,
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Garbage Entry Summary',
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green,
                      ),
                    ),
                    pw.Image(
                      pw.MemoryImage(logoBytes),
                      height: 80,
                      width: 80,
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              pw.Text(
                'Details:',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Divider(
                thickness: 2,
                color: PdfColors.green700,
              ),
              pw.SizedBox(height: 10),

              // Table to organize data
              pw.Table(
                border: pw.TableBorder.all(width: 2, color: PdfColors.green300),
                columnWidths: {
                  0: const pw.FractionColumnWidth(0.5),
                  1: const pw.FractionColumnWidth(0.5),
                },
                children: [
                  buildTableRow('User ID:', entry.userId),
                  buildTableRow('Date:', entry.date.toString()),
                  buildTableRow('Plastic Weight:', '${entry.plasticWeight} kg'),
                  buildTableRow('Glass Weight:', '${entry.glassWeight} kg'),
                  buildTableRow('Paper Weight:', '${entry.paperWeight} kg'),
                  buildTableRow('Organic Weight:', '${entry.organicWeight} kg'),
                  buildTableRow('Metal Weight:', '${entry.metelWeight} kg'),
                  buildTableRow('e-Waste Weight:', '${entry.eWasteWeight} kg'),
                  buildTableRow(
                    'Total Weight:',
                    '${entry.plasticWeight + entry.glassWeight + entry.paperWeight + entry.organicWeight + entry.metelWeight + entry.eWasteWeight} kg',
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // Footer Section
              pw.Container(
                alignment: pw.Alignment.centerRight,
                padding: const pw.EdgeInsets.all(10),
                child: pw.Text(
                  'Thank you for contributing to waste management!',
                  style: pw.TextStyle(
                    fontSize: 14,
                    color: PdfColors.green900,
                    fontStyle: pw.FontStyle.italic,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(
        bytes: await pdf.save(), filename: 'garbage_entry_summary.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green.shade200, Colors.blue.shade200],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.green),
                  onPressed: () {
                    context.go('/home'); // Use GoRouter to navigate
                  },
                ),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(
                      left: 120.0, bottom: 155.0), // Moves the text upwards
                  title: const Text(
                    'Record Garbage',
                    style: TextStyle(
                      color: Colors.green, // Sets the text color to white
                      fontWeight: FontWeight.bold, // Makes the text bold
                      fontSize: 20.0, // Adjusts the font size
                    ),
                  ),
                  background: Image.asset(
                    'assets/garbage.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFieldInput(
                            icon: Icons.person,
                            title: "User ID",
                            controller: _userId,
                            inputType: TextInputType.text,
                            validator: Validators.nullCheck),
                        const SizedBox(height: 16),
                        TextFieldInput(
                            icon: Icons.local_drink,
                            title: "Plastic/Polythene (kg)",
                            controller: _plasticWeight,
                            inputType: TextInputType.number,
                            validator: Validators.validateWeight),
                        const SizedBox(height: 16),
                        TextFieldInput(
                            icon: Icons.wine_bar,
                            title: "Glass (kg)",
                            controller: _glassWeight,
                            inputType: TextInputType.number,
                            validator: Validators.validateWeight),
                        const SizedBox(height: 16),
                        TextFieldInput(
                            icon: Icons.article,
                            title: "Paper (kg)",
                            controller: _paperWeight,
                            inputType: TextInputType.number,
                            validator: Validators.validateWeight),
                        const SizedBox(height: 16),
                        TextFieldInput(
                            icon: Icons.grass,
                            title: "Organic (kg)",
                            controller: _organicWeight,
                            inputType: TextInputType.number,
                            validator: Validators.validateWeight),
                        const SizedBox(height: 16),
                        TextFieldInput(
                            icon: Icons.home_repair_service,
                            title: "Metal (kg)",
                            controller: _metelWeight,
                            inputType: TextInputType.number,
                            validator: Validators.validateWeight),
                        const SizedBox(height: 16),
                        TextFieldInput(
                            icon: Icons.memory,
                            title: "e-Waste (kg)",
                            controller: _eWasteWeight,
                            inputType: TextInputType.number,
                            validator: Validators.validateWeight),
                        const SizedBox(height: 24),
                        SubmitButton(
                            icon: Icons.send,
                            text: "Submit Entry",
                            whenPressed: _submitEntry)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
