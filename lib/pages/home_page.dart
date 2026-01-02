import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/scan_item.dart';
import '../models/qr_item.dart';
import '../services/storage_service.dart';
import '../services/qr_service.dart'; // <— IMPORT MANCANTE
import 'scanner_page.dart';
import 'generator_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<ScanItem> storicoScansioni = [];
  List<QRItem> storicoQRGenerati = [];

  @override
  void initState() {
    super.initState();
    _caricaStorico();
  }

  Future<void> _caricaStorico() async {
    final scansioni = await StorageService.caricaScansioni();
    final qr = await StorageService.caricaQR();

    setState(() {
      storicoScansioni = scansioni;
      storicoQRGenerati = qr;
    });
  }

  void aggiungiScansione(String codice) {
    final item = ScanItem(
      codice: codice,
      data: DateTime.now().toString().substring(0, 16),
    );

    setState(() {
      storicoScansioni.insert(0, item);
    });

    StorageService.salvaScansioni(storicoScansioni);
  }

  void aggiungiQRGenerato(String testo) {
    final item = QRItem(
      testo: testo,
      data: DateTime.now().toString().substring(0, 16),
    );

    setState(() {
      storicoQRGenerati.insert(0, item);
    });

    StorageService.salvaQR(storicoQRGenerati);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR & Barcode App'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // LOGO RIDOTTO
            const Center(
              child: Icon(Icons.qr_code_scanner, size: 60, color: Colors.blue),
            ),

            const SizedBox(height: 20),

            // Bottone SCANSIONA
            ElevatedButton.icon(
              onPressed: () async {
                final risultato = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScannerPage()),
                );
                if (risultato != null) {
                  aggiungiScansione(risultato);
                }
              },
              icon: const Icon(Icons.camera_alt, size: 24),
              label: const Text(
                'Scansiona QR/Barcode',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Bottone CREA
            ElevatedButton.icon(
              onPressed: () async {
                final risultato = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GeneratorPage(),
                  ),
                );
                if (risultato != null) {
                  aggiungiQRGenerato(risultato);
                }
              },
              icon: const Icon(Icons.qr_code, size: 24),
              label: const Text('Crea QR Code', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ============================
            // SEZIONE SCANSIONI
            // ============================
            const Text(
              'Scansioni Recenti',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Container(
              height: 140, // RIDOTTA
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: storicoScansioni.isEmpty
                  ? const Center(child: Text("Nessuna scansione"))
                  : ListView.builder(
                      itemCount: storicoScansioni.length,
                      itemBuilder: (context, index) {
                        final item = storicoScansioni[index];
                        return ListTile(
                          leading: const Icon(
                            Icons.qr_code_scanner,
                            color: Colors.blue,
                          ),
                          title: Text(
                            item.codice,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(item.data),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () =>
                              _mostraDettagliScansione(context, item.codice),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 18),

            // DIVIDER GRAFICO COMPATTO
            Center(
              child: Container(
                width: 160,
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withValues(alpha: 0.2),
                      Colors.blue,
                      Colors.blue.withValues(alpha: 0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ============================
            // SEZIONE QR GENERATI
            // ============================
            const Text(
              'QR Code Generati',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Container(
              height: 200, // AUMENTATA
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: storicoQRGenerati.isEmpty
                  ? const Center(child: Text("Nessun QR generato"))
                  : ListView.builder(
                      itemCount: storicoQRGenerati.length,
                      itemBuilder: (context, index) {
                        final item = storicoQRGenerati[index];
                        return ListTile(
                          leading: const Icon(
                            Icons.qr_code,
                            color: Colors.green,
                          ),
                          title: Text(
                            item.testo,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(item.data),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () => _mostraQRGenerato(context, item.testo),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostraDettagliScansione(BuildContext context, String codice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dettagli Scansione'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: QrImageView(data: codice, version: QrVersions.auto),
            ),
            const SizedBox(height: 10),
            SelectableText(codice, textAlign: TextAlign.center),
          ],
        ),
        actions: [
          // APRI LINK SE È URL
          if (codice.startsWith("http"))
            TextButton(
              onPressed: () async {
                final uri = Uri.parse(codice);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              child: const Text("Apri link"),
            ),

          // COPIA
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: codice));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copiato negli appunti!')),
              );
            },
            child: const Text("Copia"),
          ),

          // CONDIVIDI
          TextButton(
            onPressed: () async {
              await Share.share(codice);
            },
            child: const Text("Condividi"),
          ),

          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Chiudi"),
          ),
        ],
      ),
    );
  }

  void _mostraQRGenerato(BuildContext context, String testo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('QR Code Generato'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: QrImageView(data: testo, version: QrVersions.auto),
            ),
            const SizedBox(height: 10),
            SelectableText(testo, textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await QRService.salvaQRComeImmagine(testo);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Immagine salvata!")),
              );
            },
            child: const Text("Salva immagine"),
          ),

          TextButton(
            onPressed: () async {
              final path = await QRService.salvaQRComeImmagine(testo);
              await QRService.condividiQR(path);
            },
            child: const Text("Condividi"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Chiudi"),
          ),
        ],
      ),
    );
  }
}
