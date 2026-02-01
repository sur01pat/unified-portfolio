import 'package:flutter/material.dart';

import '../../auth/services/token_storage.dart';
import '../../auth/screens/mobile_input_screen.dart';

import '../services/portfolio_api.dart';
import 'portfolio_list_screen.dart';
import 'portfolio_insights_screen.dart';
import 'fixed_income_maturity_screen.dart';

import '../../accounts/screens/connected_accounts_screen.dart';
import '../../integrations/screens/connected_providers_screen.dart';
import '../../notifications/screens/notifications_screen.dart';
import '../../notifications/services/notifications_api.dart';
import '../../shared/widgets/notification_badge.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<Map<String, dynamic>> _summary;
  late Future<int> _unreadCount;

  @override
  void initState() {
    super.initState();
    _refreshAll();
  }

  void _refreshAll() {
    _summary = PortfolioApi.getSummary();
    _unreadCount = NotificationsApi.getUnreadCount();
  }

  Future<void> _logout() async {
    await TokenStorage.clearToken();
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MobileInputScreen()),
      (_) => false,
    );
  }

  void _openInsights() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PortfolioInsightsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Portfolio'),
        actions: [
          /// 🔔 Notifications
          FutureBuilder<int>(
            future: _unreadCount,
            builder: (context, snapshot) {
              final count = snapshot.data ?? 0;
              return NotificationBadge(
                count: count,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsScreen(),
                    ),
                  );
                  setState(() {
                    _unreadCount = NotificationsApi.getUnreadCount();
                  });
                },
              );
            },
          ),

          /// 🔗 Connected Providers
          IconButton(
            icon: const Icon(Icons.hub),
            tooltip: 'Connected Providers',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ConnectedProvidersScreen(),
                ),
              );
            },
          ),

          /// 🔗 Connected Accounts
          IconButton(
            icon: const Icon(Icons.link),
            tooltip: 'Connected Accounts',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ConnectedAccountsScreen(),
                ),
              );
            },
          ),

          /// 📊 Insights
          IconButton(
            icon: const Icon(Icons.insights),
            tooltip: 'Insights',
            onPressed: _openInsights,
          ),

          /// 📅 FD Maturities (separate screen)
          IconButton(
            icon: const Icon(Icons.event),
            tooltip: 'FD Maturities',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FixedIncomeMaturityScreen(),
                ),
              );
            },
          ),

          /// 🔄 Refresh
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(_refreshAll);
            },
          ),

          /// 🚪 Logout
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),

      body: Column(
        children: [
          /// 🔹 COMPACT SUMMARY ROW (1 LINE)
          FutureBuilder<Map<String, dynamic>>(
            future: _summary,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();

              final s = snapshot.data!;
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _compactMetric('Invested', s['investedValue']),
                    _compactMetric('Current', s['currentValue']),
                    _compactMetric('P/L', s['pnl']),
                  ],
                ),
              );
            },
          ),

          /// 🔹 PORTFOLIO LIST (PRIMARY CONTENT)
          Expanded(
            child: PortfolioListScreen(
              onChanged: () {
                setState(_refreshAll);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Compact metric used in summary row
  Widget _compactMetric(String label, dynamic value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        const SizedBox(height: 2),
        Text(
          '₹${(value as num).toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}




