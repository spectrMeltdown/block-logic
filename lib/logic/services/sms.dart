import 'package:block_logic/logic/services/error_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

part 'generated/sms.g.dart';

@riverpod
class SmsService extends _$SmsService {
  @override
  SmsServiceState build() {
    final errorHandler = ref.read(errorHandlerProvider.notifier);
    final instance = TwilioFlutter(
        accountSid: 'AC0fbc095eb856e8aee72feb40170bbda8',
        authToken: '66950e6996e5019da79aa6ab459f615b',
        twilioNumber: '');
    return SmsServiceState(errorHandler: errorHandler, instance: instance);
  }

  Future<String?> get(String messageSid) async {
    try {
      final response = await state._instance.getSMS(messageSid);
      if (response.responseState == ResponseState.SUCCESS) {
        return null;
      }
      if (response.errorData?.message != null) {
        return response.errorData!.message;
      }
      return 'Failed to get SMS.';
    } catch (e) {
      return state._errorHandler.call(e);
    }
  }

  Future<String?> send(String number, String message) async {
    try {
      final response = await state._instance.sendSMS(toNumber: number, messageBody: message);
      if (response.responseState == ResponseState.SUCCESS) {
        return null;
      }
      if (response.errorData?.message != null) {
        return response.errorData!.message;
      }
      return 'Verification not sent.';
    } catch (e) {
      return state._errorHandler.call(e);
    }
  }
}

class SmsServiceState {
  final ErrorHandler _errorHandler;
  final TwilioFlutter _instance;

  SmsServiceState({required ErrorHandler errorHandler, required TwilioFlutter instance})
      : _errorHandler = errorHandler,
        _instance = instance;
}
