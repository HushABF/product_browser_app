import 'dart:async';

import 'package:flutter/widgets.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription _subscription;

  GoRouterRefreshStream({required Stream stream}) {
    _subscription = stream.listen((_) => notifyListeners());
  }
  
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
