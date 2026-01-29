import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'features/auth/screens/mobile_input_screen.dart';
import 'features/auth/services/token_storage.dart';
import 'features/portfolio/screens/dashboard_screen.dart';

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  Future<Widget> _startScreen() async {
    final token = await TokenStorage.getToken();
    return token == null
        ? const MobileInputScreen()
        : const DashboardScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      /// 🔥 FORCE ENGLISH LOCALE
      locale: const Locale('en', 'US'),
      supportedLocales: const [
        Locale('en', 'US'),
      ],

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: FutureBuilder<Widget>(
        future: _startScreen(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.data!;
        },
      ),
    );
  }
}

