import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Secure {
  static final _key = Key.fromUtf8(dotenv.env['ENCRYPTED_KEY']!);
  static final _b64key =
      Key.fromUtf8(base64Url.encode(_key.bytes).substring(0, 32));

  static final _fernet = Fernet(_b64key);
  static final _encrypter = Encrypter(_fernet);

  static String secureText(String text) {
    return _encrypter.encrypt(text).base64;
  }

  static String unSecureText(String secureText) {
    return _encrypter.decrypt(Encrypted.fromBase64(secureText));
  }
}
