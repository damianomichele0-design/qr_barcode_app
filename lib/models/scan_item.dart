class ScanItem {
  final String codice;
  final String data;

  ScanItem({required this.codice, required this.data});

  @override
  String toString() => "$codice|$data";

  static ScanItem fromString(String s) {
    final parts = s.split('|');
    return ScanItem(codice: parts[0], data: parts[1]);
  }
}
