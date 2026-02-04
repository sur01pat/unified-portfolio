import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatService {
  static const _entitlementId = 'premium';
  static bool _configured = false;

  static Future<void> init() async {
    if (_configured) return;
    if (!kReleaseMode) return;

    final apiKey = Platform.isAndroid
        ? 'goog_jOCCCMWjCGBpsGbrOAOQniLWmLV'
        : 'PASTE_IOS_PUBLIC_SDK_KEY_HERE';

    await Purchases.configure(
      PurchasesConfiguration(apiKey),
    );

    _configured = true;
  }

  static Future<bool> isPremium() async {
    if (!kReleaseMode) return false;
    await Purchases.syncPurchases();   // FORCE refresh from Play Store
    final info = await Purchases.getCustomerInfo();
    return info.entitlements.active.containsKey(_entitlementId);
  }

  static Future<void> showPaywall() async {
    if (!kReleaseMode) return;

    final offerings = await Purchases.getOfferings();
    final current = offerings.current;
    if (current == null) {
      throw Exception('No current offering found');
    }

    await Purchases.purchasePackage(
      current.availablePackages.first,
    );
  }
}



