import 'package:flutter/material.dart';
import '../services/portfolio_api.dart';

/// NOTE:
/// Premium gating is intentionally UI-only for now.
/// TODO(RevenueCat):
/// - Integrate RevenueCat paywall here for Play Store release builds
/// - Enforce premium access only in kReleaseMode
/// - Do NOT bypass gating in release builds
class PortfolioInsightsScreen extends StatelessWidget {
  const PortfolioInsightsScreen({super.key});

  // TEMP: premium flag (replace with RevenueCat later)
  static const bool isPremiumUser = false;

  @override
  Widget build(BuildContext context) {
    if (!isPremiumUser) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Risk & Diversification'),
        ),
        body: _lockedView(context),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Risk & Diversification'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: PortfolioApi.getAnalysis(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No analysis available'));
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
              if ((data['warnings'] as List?)?.isNotEmpty ?? false) ...[
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
                    leading:
                        const Icon(Icons.warning, color: Colors.orange),
                    title: Text(w),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _lockedView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 48, color: Colors.grey),
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
            ElevatedButton(
              onPressed: () {
                // 🔒 PREMIUM PAYWALL PLACEHOLDER
                // TODO(RevenueCat):
                // - Launch RevenueCat paywall here
                // - Enforce premium only in Play Store (kReleaseMode)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Premium upgrade coming soon'),
                  ),
                );
              },
              child: const Text('Upgrade to Premium'),
            ),
          ],
        ),
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
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
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


