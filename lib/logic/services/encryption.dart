import 'package:encrypt/encrypt.dart' as encrypt_lib;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/encryption.g.dart';

@riverpod
class Encryption extends _$Encryption {
  @override
  Encryption build() {
    return Encryption();
  }

  encrypt_lib.Encrypter getEncrypter(String initialKey) {
    assert(initialKey.length == 32);

    /// use firebase_auth id, appended and prepended with '==' symbols to reach a length of 32
    final uniqueString = '==$initialKey==';
    final key = encrypt_lib.Key.fromUtf8(uniqueString);
    final encrypter =
        encrypt_lib.Encrypter(encrypt_lib.AES(key, padding: null));
    return encrypter;
  }

  encrypt_lib.IV getIV() {
    /// allZerosOfLength required when setting padding = null
    return encrypt_lib.IV.allZerosOfLength(16);
  }

  String encryptString(
      {required String plainText, required String initialKey}) {
    if (plainText.isEmpty) return '';
    final String encrypted =
        getEncrypter(initialKey).encrypt(plainText, iv: getIV()).base64;
    return encrypted;
  }

  String decryptString(
      {required String encryptedText, required String initialKey}) {
    if (encryptedText.isEmpty) return '';
    final String decrypted =
        getEncrypter(initialKey).decrypt64(encryptedText, iv: getIV());
    return decrypted;
  }
}
