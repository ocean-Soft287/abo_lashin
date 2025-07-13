import 'package:flutter/cupertino.dart';
import 'package:share_plus/share_plus.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

Future<String> downloadImage(String imageUrl) async {
  var dio = Dio();
  String dir = (await getTemporaryDirectory()).path;
  String fileName = imageUrl.split('/').last;
  String filePath = '$dir/$fileName';
  await dio.download(imageUrl, filePath);
  return filePath;
}

Future<void> shareContent({
  required String link,
  required String name,
  required String imagePath,
  required BuildContext context,
}) async {
  try {

    String localImagePath = await downloadImage(imagePath);


    await Share.shareXFiles(
      [XFile(localImagePath)],
      text: '$link\n$name',
    ).then((_) {
      Navigator.pop(context);
    });
  } catch (error) {

  }
}
