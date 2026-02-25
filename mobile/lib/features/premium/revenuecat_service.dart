import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatService {
  static const String _entitlementId = 'premium';
  static bool _configured = false;

  /// Call once from main()
  static Future<void> init() async {
    if (_configured) return;
    if (!kReleaseMode) return;

    final apiKey = Platform.isAndroid
        ? 'goog_jOCCCMWjCGBpsGbrOAOQniLWmLV'
        : 'PASTE_IOS_PUBLIC_KEY';

    await Purchases.configure(
      PurchasesConfiguration(apiKey),
    );

    _configured = true;
  }

  /// 🔁 Force refresh from Play Store
  static Future<bool> isPremium() async {
    if (!kReleaseMode) return false;

    await Purchases.syncPurchases();
    final info = await Purchases.getCustomerInfo();

    return info.entitlements.active.containsKey(_entitlementId);
  }

  /// 💳 Open paywall OR restore silently if owned
  static Future<void> showPaywall() async {
    if (!kReleaseMode) return;

    final offerings = await Purchases.getOfferings();
    final current = offerings.current;

    if (current == null) {
      throw Exception('No offerings configured in RevenueCat');
    }

    await Purchases.purchasePackage(
      current.availablePackages.first,
    );
  }
}




