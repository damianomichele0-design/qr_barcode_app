import 'package:shared_preferences/shared_preferences.dart';
import '../models/scan_item.dart';
import '../models/qr_item.dart';

class StorageService {
  static const String scansioniKey = "storicoScansioni";
  static const String qrKey = "storicoQRGenerati";

  static Future<void> salvaScansioni(List<ScanItem> scansioni) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
      scansioniKey,
      scansioni.map((e) => e.toString()).toList(),
    );
  }

  static Future<void> salvaQR(List<QRItem> qr) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(qrKey, qr.map((e) => e.toString()).toList());
  }

  static Future<List<ScanItem>> caricaScansioni() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(scansioniKey) ?? [];
    return list.map((e) => ScanItem.fromString(e)).toList();
  }

  static Future<List<QRItem>> caricaQR() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(qrKey) ?? [];
    return list.map((e) => QRItem.fromString(e)).toList();
  }
}
