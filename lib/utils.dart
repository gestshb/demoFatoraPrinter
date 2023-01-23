import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'dart:ui' as ui;

class Utils {
  static Future capture(GlobalKey key) async {
    RenderRepaintBoundary? boundary =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary?;
    final image = await boundary!.toImage(pixelRatio: 4);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();
    return pngBytes;
  }
}
