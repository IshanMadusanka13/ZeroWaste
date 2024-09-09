import 'package:flutter/widgets.dart';

class CustomBins {
  CustomBins._();

  static const _kFontFam = 'CustomBins';
  static const String? _kFontPkg = null;

  static const IconData metalbin =
      IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData organicwaste =
      IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData paperbin =
      IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData plasticbin =
      IconData(0xe803, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData woodbin =
      IconData(0xe804, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData batterybin =
      IconData(0xe805, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData medicalwaste =
      IconData(0xe806, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  static IconData getBinIcon(String binType) {
    switch (binType) {
      case 'Plastic':
        return CustomBins.plasticbin;
      case 'Metal':
        return CustomBins.metalbin;
      case 'Paper':
        return CustomBins.paperbin;
      case 'Organic':
        return CustomBins.organicwaste;
      case 'Wood':
        return CustomBins.woodbin;
      case 'Battery':
        return CustomBins.batterybin;
      case 'Medical':
        return CustomBins.medicalwaste;
      default:
        return CustomBins.plasticbin;
    }
  }
}
