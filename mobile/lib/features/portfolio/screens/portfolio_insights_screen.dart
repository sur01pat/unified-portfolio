import 'package:flutter/material.dart';

import '../services/portfolio_api.dart';
import '../../../services/premium_service.dart';
import '../../../widgets/premium_paywall.dart';

class PortfolioInsightsScreen extends StatefulWidget {
  const PortfolioInsightsScreen({super.key});

  @override
  State<PortfolioInsightsScreen> createState() =>
      _PortfolioInsightsScreenState();
}

class _PortfolioInsightsScreenState
    extends State<PortfolioInsightsScreen> {
  late Future<bool> _premiumFuture;

  @override
  void initState() {
    super.initState();

    // 🔒 Force paywall first in debug (for testing)
    PremiumService.disableDebugPremium();

    _premiumFuture = PremiumService.isPremium();
  }

  /// 🔄 Re-check premium after upgrade
  void _refreshPremium() {
    setState(() {
      _premiumFuture = PremiumService.isPremium();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _premiumFuture,
      builder: (context, premiumSnapshot) {
        if (!premiumSnapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        /// 🔒 NOT PREMIUM → INLINE PAYWALL
        if (!premiumSnapshot.data!) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Risk & Diversification'),
            ),
            body: PremiumPaywall(
              onUpgraded: _refreshPremium, // 🔑 FIX
            ),
          );
        }

        /// ✅ PREMIUM → SHOW ANALYSIS (NO NAVIGATION)
        return Scaffold(
          appBar: AppBar(
            title: const Text('Risk & Diversification'),
          ),
          body: FutureBuilder<Map<String, dynamic>>(
            future: PortfolioApi.getAnalysis(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final data = snapshot.data!;

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _section(
                    'Asset Allocation (%)',
                    Map<String, dynamic>.from(data['allocation']),
                  ),
                  _section(
                    'Country Exposure (%)',
                    Map<String, dynamic>.from(data['countryExposure']),
                  ),
                  _section(
                    'Sector Exposure (%)',
                    Map<String, dynamic>.from(data['sectorExposure']),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Warnings',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...List<String>.from(data['warnings']).map(
                    (w) => ListTile(
                      leading: const Icon(
                        Icons.warning,
                        color: Colors.orange,
                      ),
                      title: Text(w),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _section(String title, Map<String, dynamic> values) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...values.entries.map(
          (e) => ListTile(
            title: Text(e.key),
            trailing: Text('${e.value}%'),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

