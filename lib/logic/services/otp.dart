// import 'package:block_logic/logic/services/random_num.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'generated/otp.g.dart';

// @riverpod
// class OtpService extends _$OtpService {
//   @override
//   OtpServiceState build() {
//     final randNum = ref.read(randomNumProvider.notifier);
//     return OtpServiceState(randNum);
//   }

//   int getOTP() {
//     return state.randInstance.getRandomInt(900000, 100000);
//   }
// }

// class OtpServiceState {
//   final RandomNum randInstance;

//   OtpServiceState(this.randInstance);
// }
