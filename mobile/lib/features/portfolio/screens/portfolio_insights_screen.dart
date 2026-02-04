import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../services/portfolio_api.dart';
import '../../premium/revenuecat_service.dart';

class PortfolioInsightsScreen extends StatefulWidget {
  const PortfolioInsightsScreen({super.key});

  @override
  State<PortfolioInsightsScreen> createState() =>
      _PortfolioInsightsScreenState();
}

class _PortfolioInsightsScreenState extends State<PortfolioInsightsScreen> {
  bool _loading = true;
  bool _isPremium = false;

  @override
  void initState() {
    super.initState();
    _checkPremium();
  }

  Future<void> _checkPremium() async {
    if (!kReleaseMode) {
      // 🚫 Debug/dev builds: treat as non-premium
      setState(() {
        _isPremium = false;
        _loading = false;
      });
      return;
    }

    final premium = await RevenueCatService.isPremium();
    setState(() {
      _isPremium = premium;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // ✅ Already premium → DIRECT access
    if (_isPremium) {
      return _insightsView();
    }

    // 🔒 First-time / non-premium → locked view
    return _lockedView();
  }

  /// 🔒 Locked screen (ONLY for non-premium users)
  Widget _lockedView() {
    return Scaffold(
      appBar: AppBar(title: const Text('Risk & Diversification')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 48),
              const SizedBox(height: 16),
              const Text(
                'Premium Feature',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Risk & diversification insights are available for premium users.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              /// 💳 Upgrade ONLY for first-time users
              ElevatedButton(
                onPressed: () async {
                  try {
                    await RevenueCatService.showPaywall();
                  } catch (_) {
                    // Ignore "already subscribed" etc
                  } finally {
                    // 🔁 Re-check entitlement after purchase
                    await _checkPremium();
                  }
                },
                child: const Text('Upgrade to Premium'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 📊 Premium insights view
  Widget _insightsView() {
    return Scaffold(
      appBar: AppBar(title: const Text('Risk & Diversification')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: PortfolioApi.getAnalysis(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _section(
                'Asset Allocation (%)',
                Map<String, dynamic>.from(data['allocation'] ?? {}),
              ),
              _section(
                'Country Exposure (%)',
                Map<String, dynamic>.from(data['countryExposure'] ?? {}),
              ),
              _section(
                'Sector Exposure (%)',
                Map<String, dynamic>.from(data['sectorExposure'] ?? {}),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _section(String title, Map<String, dynamic> values) {
    if (values.isEmpty) return const SizedBox.shrink();

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








