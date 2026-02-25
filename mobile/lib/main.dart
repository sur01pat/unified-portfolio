import 'package:flutter/material.dart';
import 'app.dart';
import 'features/premium/revenuecat_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Fire-and-forget (non-blocking)
  RevenueCatService.init();

  runApp(const PortfolioApp());
}

