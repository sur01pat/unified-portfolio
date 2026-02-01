import 'package:flutter/material.dart';
import '../services/portfolio_api.dart';

class PortfolioInsightsScreen extends StatelessWidget {
  const PortfolioInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Risk & Diversification'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: PortfolioApi.getAnalysis(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

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
              child: Text('No analysis available'),
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
  }

  Widget _section(String title, Map<String, dynamic> values) {
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


