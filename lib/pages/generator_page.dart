import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../services/qr_service.dart';

class GeneratorPage extends StatefulWidget {
  const GeneratorPage({super.key});

  @override
  GeneratorPageState createState() => GeneratorPageState();
}

class GeneratorPageState extends State<GeneratorPage> {
  final TextEditingController testoController = TextEditingController();
  String testoQR = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Genera QR Code')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: testoController,
                decoration: const InputDecoration(
                  labelText: 'Inserisci testo o URL',
                  border: OutlineInputBorder(),
                  hintText: 'Es: https://www.google.com',
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: () {
                  if (testoController.text.isNotEmpty) {
                    setState(() {
                      testoQR = testoController.text;
                    });
                  }
                },
                icon: const Icon(Icons.create),
                label: const Text('Genera QR Code'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              if (testoQR.isNotEmpty)
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: SizedBox(
                        width: 250,
                        height: 250,
                        child: QrImageView(
                          data: testoQR,
                          version: QrVersions.auto,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context, testoQR);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('QR Code salvato!')),
                            );
                          },
                          icon: const Icon(Icons.save),
                          label: const Text('Salva'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              testoQR = '';
                              testoController.clear();
                            });
                          },
                          icon: const Icon(Icons.clear),
                          label: const Text('Cancella'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            await QRService.salvaQRComeImmagine(testoQR);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Immagine salvata!"),
                              ),
                            );
                          },
                          icon: const Icon(Icons.image),
                          label: const Text("Salva immagine"),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final path = await QRService.salvaQRComeImmagine(
                              testoQR,
                            );
                            await QRService.condividiQR(path);
                          },
                          icon: const Icon(Icons.share),
                          label: const Text("Condividi"),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
