import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'pyxis_pedido.dart';

class QRCodePage extends StatefulWidget {
  const QRCodePage({super.key});

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  String pixy = '';

  @override
  void initState() {
    super.initState();
    // readQRCode();
  }

  readQRCode() async {
    String code = await FlutterBarcodeScanner.scanBarcode(
      "#FFFFFF",
      "Cancelar",
      false,
      ScanMode.QR,
    );
    if (code != '-1') {
      print(pixy);
      setState(() => pixy = code);
      Navigator.push(
        mounted as BuildContext,
        MaterialPageRoute(
          builder: (mounted) => PyxisPedidoPage(qrCode: pixy),
        ),
      );
    } else {
      setState(() => pixy = 'Não validado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: SizedBox(
            height: (MediaQuery.of(context).size.height / 100) * 16,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (pixy != '')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      'Pixy: $pixy',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ElevatedButton.icon(
                  onPressed: readQRCode,
                  style: ButtonStyle(
                    fixedSize:
                        WidgetStateProperty.all<Size>(const Size(200, 60)),
                  ),
                  icon: const Icon(Icons.qr_code),
                  label: const Text('Escanear Pixys'),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    fixedSize:
                        WidgetStateProperty.all<Size>(const Size(200, 60)),
                  ),
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height:
                              (MediaQuery.of(context).size.height / 100) * 50,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Text('Todos os Pixys'),
                                ElevatedButton(
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.close),
                                      Text('Voltar'),
                                    ],
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: snapshot.data!.tasks.length,
                                    itemBuilder: (context, index) {
                                      final task = snapshot.data!.tasks[index];
                                      return TaskTile(
                                        task: task,
                                        onDelete: () =>
                                            _deleteTaskAndRefreshList(task.id),
                                        onUpdate: () =>
                                            _updateTaskAndRefreshList(task.id),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.list_outlined),
                        Text('Selecionar Pixys'),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
