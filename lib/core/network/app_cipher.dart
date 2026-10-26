import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypt;

abstract final class AppCipher {
  AppCipher._();
  static const String privateKey = '544554869355d15a8c98b9b6428bf3c3';
  static const String publicKey = '0ed19ea59a8637c6';
 //text
 //  static const String privateKey = 'c104780a25b4f80c037445dd1f6947e1';
 //  static const String publicKey = 'e0c9de1b2de26fe2';
  static final encrypt.Encrypter _encrypter = encrypt.Encrypter(
    encrypt.AES(encrypt.Key.fromUtf8(privateKey), mode: encrypt.AESMode.cbc),
  );
  static final encrypt.IV _iv = encrypt.IV.fromUtf8(publicKey);

  static String encryptText(String plainText) =>
      _encrypter.encrypt(plainText, iv: _iv).base64;

  static String encryptMap(Map<String, dynamic> data) =>
      encryptText(json.encode(data));

  static String decryptText(String encryptedText) {
    try {
      return _encrypter.decrypt(
        encrypt.Encrypted.fromBase64(encryptedText.trim()),
        iv: _iv,
      );
    } catch (error) {
      throw FormatException('Unable to decrypt server response: $error');
    }
  }
}
