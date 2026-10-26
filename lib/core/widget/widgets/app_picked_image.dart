import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppPickedImage extends StatelessWidget {
  const AppPickedImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
  });

  final String path;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? Image.network(
          path,
          fit: fit,
          width: double.infinity,
          height: double.infinity,
        )
        : Image.file(
          File(path),
          fit: fit,
          width: double.infinity,
          height: double.infinity,
        );
  }
}
