import 'dart:typed_data';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:printer/utils.dart';
import 'package:printer/widget_to_image.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Printer Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: const MyHomePage(title: 'printer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey? key1;
  GlobalKey? key2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            WidgetToImage(
              builder: (key) {
                key1 = key;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text("فاتورة"),
                    Text("التاريخ 30/10/2021"),
                    Text("------------------------"),
                  ],
                );
              },
            ),
            WidgetToImage(
              builder: (key) {
                key2 = key;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text("  جهاز حاسوب 5  *   50 =   250 دينار  "),
                    Text("------------------------"),
                    Text("المجموع : 250 دينار "),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final bytes1 = await Utils.capture(key1!);
          final bytes2 = await Utils.capture(key2!);
          final List<Uint8List> bytes = [bytes1, bytes2];
          printToPrinter(bytes);
        },
        child: const Icon(Icons.print),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void printToPrinter(List<Uint8List> bytes) async {
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);

    final PosPrintResult res =
        await printer.connect('192.168.1.164', port: 9100);

    if (res == PosPrintResult.success) {
      print('Print result: ${res.msg}');
      for (var element in bytes) {
        final image = decodeImage(element);
        printer.image(image!);
        printer.cut();
      }

      printer.disconnect();
    }
  }
}
