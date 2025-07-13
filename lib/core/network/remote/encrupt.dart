import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypt;

const privateKey = '544554869355d15a8c98b9b6428bf3c3';
const publicKey = '0ed19ea59a8637c6';




dynamic decrypt(String encryptedText, String privateKey, String publicKey) {
  final keyObj = encrypt.Key.fromUtf8(privateKey);
  final ivObj = encrypt.IV.fromUtf8(publicKey);
  final encrypter = encrypt.Encrypter(encrypt.AES(keyObj, mode: encrypt.AESMode.cbc));

  try {
    final decrypted = encrypter.decrypt(encrypt.Encrypted.fromBase64(encryptedText), iv: ivObj);
    return decrypted;
  } catch (e) {
    return 'Error....................';
  }
}
String encryptData(Map<String,dynamic> data, String privateKey, String publicKey) {
  final key = encrypt.Key.fromUtf8(privateKey);
  final iv = encrypt.IV.fromUtf8(publicKey);
  final encrypter = encrypt.Encrypter(
    encrypt.AES(key, mode: encrypt.AESMode.cbc),
  );
  try{

    String jsonString = json.encode(data);
    final encrypted = encrypter.encrypt(jsonString, iv: iv);
    final encryptedText = encrypted.base64;
    return encryptedText;

  }
  catch(e){
    return 'Error....................';
  }

}
