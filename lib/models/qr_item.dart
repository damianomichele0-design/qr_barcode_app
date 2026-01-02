class QRItem {
  final String testo;
  final String data;

  QRItem({required this.testo, required this.data});

  @override
  String toString() => "$testo|$data";

  static QRItem fromString(String s) {
    final parts = s.split('|');
    return QRItem(testo: parts[0], data: parts[1]);
  }
}
