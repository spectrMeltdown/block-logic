import 'dart:convert';

import 'package:block_logic/logic/dev.dart';
import 'package:block_logic/logic/services/error_handler.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/email.g.dart';

@riverpod
class EmailService extends _$EmailService {
  @override
  EmailServiceState build() {
    final errorHandler = ref.read(errorHandlerProvider.notifier);
    return EmailServiceState(errorHandler: errorHandler);
  }

  Future<String?> send(Map<String, String> template) async {
    try {
      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
      final response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: json.encode({'template_id': 'template_ozw8xsg', 'service_id': 'service_qsw1zlg', 'user_id': 'apazwD7SrRfQqT892', 'accessToken': 'bEzatc-C6xiSF6f-z_g1d', 'template_params': template}));
      dPrint('Login alert: ${response.body}');
      return response.statusCode.toString();
    } catch (e) {
      return state._errorHandler.call(e, this);
    }
  }
}

class EmailServiceState {
  final ErrorHandler _errorHandler;

  EmailServiceState({required ErrorHandler errorHandler}) : _errorHandler = errorHandler;
}
