import 'package:block_logic/logic/enums.dart';
import 'package:block_logic/logic/services/toast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/internet_connection.g.dart';

@Riverpod(keepAlive: true)
class InternetStatus extends _$InternetStatus {
  bool _initialCheck = true; // to avoid displaying when app has first started
  Toast? _toast;
  @override
  void build() {
    _toast = ref.read(toastProvider.notifier);
    _initialize();
  }

  void _initialize() {
    // InternetConnectionChecker().onStatusChange.listen((status) {
    //   final isConnected = status == InternetConnectionStatus.connected;
    //   if (!_initialCheck) {
    //     _showToast(isConnected);
    //   } else {
    //     _initialCheck = false;
    //   }
    // });
  }

  void _showToast(bool isConnected) {
    if (isConnected) {
      _toast?.showToast('Connection restored.', type: NotifType.success);
    } else {
      _toast?.showToast('Connection lost.', type: NotifType.error);
    }
    // WidgetsBinding.instance.addPostFrameCallback((_) {

    // });
  }
}
