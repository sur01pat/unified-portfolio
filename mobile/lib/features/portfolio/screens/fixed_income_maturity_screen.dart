import 'package:flutter/material.dart';
import '../services/portfolio_api.dart';

class FixedIncomeMaturityScreen extends StatelessWidget {
  const FixedIncomeMaturityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fixed Income Maturities')),
      body: FutureBuilder<List<dynamic>>(
        future: PortfolioApi.getMaturities(),
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
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;
          if (items.isEmpty) {
            return const Center(child: Text('No fixed income investments'));
          }

          return ListView(
            children: items.map((m) {
              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text(m['name']),
                  subtitle: Text(
                    'Maturity: ${m['maturityDate']}',
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('₹${m['amount']}'),
                      Text(
                        '${m['daysRemaining']} days',
                        style: TextStyle(
                          color: m['status'] == 'DUE_SOON'
                              ? Colors.orange
                              : m['status'] == 'MATURED'
                                  ? Colors.red
                                  : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
