import 'dart:io';
import 'dart:ui';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class QRService {
  static Future<String> salvaQRComeImmagine(String data) async {
    final qrValidationResult = QrValidator.validate(
      data: data,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.M,
    );

    if (qrValidationResult.status != QrValidationStatus.valid) {
      throw Exception("QR non valido");
    }

    final qrCode = qrValidationResult.qrCode!;
    final painter = QrPainter.withQr(
      qr: qrCode,
      gapless: true,
      dataModuleStyle: const QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: Color(0xFF000000), // colore dei moduli del QR
      ),
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: Color(0xFF000000), // colore degli occhi del QR
      ),
    );

    final tempDir = await getTemporaryDirectory();
    final filePath =
        '${tempDir.path}/qr_${DateTime.now().millisecondsSinceEpoch}.png';

    final picData = await painter.toImageData(
      2048,
      format: ImageByteFormat.png,
    );
    final bytes = picData!.buffer.asUint8List();

    final file = File(filePath);
    await file.writeAsBytes(bytes);

    return filePath;
  }

  static Future<void> condividiQR(String path) async {
    await Share.shareXFiles([XFile(path)], text: "Ecco il mio QR Code");
  }
}
