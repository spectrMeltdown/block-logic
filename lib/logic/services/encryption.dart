import 'package:encrypt/encrypt.dart' as encrypt_lib;
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/encryption.g.dart';

@riverpod
class Encryption extends _$Encryption {
  @override
  void build() {}

  String decryptString({required String encrypted, required String key}) {
    if (encrypted.isEmpty) return encrypted;
    if (key.isEmpty) throw (ArgumentError('Key should not be blank!'));
    final String decrypted =
        _getEncrypter(key).decrypt64(encrypted, iv: _getIV());
    return decrypted;
  }

  String encryptString({required String text, required String key}) {
    if (text.isEmpty) return text;
    if (key.isEmpty) throw (ArgumentError('Key should not be blank!'));
    final String encrypted =
        _getEncrypter(key).encrypt(text, iv: _getIV()).base64;
    return encrypted;
  }

  encrypt_lib.Encrypter _getEncrypter(String key) {
    debugPrint(key.length.toString());
    //assert(key.length == 32);

    /// use firebase_auth id, appended and prepended with '==' symbols to reach a length of 32
    final uniqueString = 'bl${key}bl';
    final finalKey = encrypt_lib.Key.fromUtf8(uniqueString);
    final encrypter =
        encrypt_lib.Encrypter(encrypt_lib.AES(finalKey, padding: null));
    return encrypter;
  }

  encrypt_lib.IV _getIV() {
    /// allZerosOfLength required when setting padding = null
    return encrypt_lib.IV.allZerosOfLength(16);
  }
}
