import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatBootstrap {
  static bool _initialized = false;

  static Future<void> init() async {
    // 🚫 NEVER run RevenueCat in debug/profile
    if (!kReleaseMode) {
      debugPrint('[RC] Skipped (not release mode)');
      return;
    }

    if (_initialized) return;

    try {
      final apiKey = Platform.isAndroid
          ? 'goog_bRufsawqUbHoNUiXbkbGgUzWVjX'
          : 'YOUR_IOS_PUBLIC_SDK_KEY';

      await Purchases.configure(
        PurchasesConfiguration(apiKey),
      );

      _initialized = true;
      debugPrint('[RC] Initialized');
    } catch (e) {
      debugPrint('[RC] Init failed: $e');
    }
  }
}

