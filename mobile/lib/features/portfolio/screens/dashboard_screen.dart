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
  late Future<List<dynamic>> _maturities;
  late Future<int> _unreadCount;

  @override
  void initState() {
    super.initState();
    _refreshAll();
  }

  void _refreshAll() {
    _summary = PortfolioApi.getSummary();
    _maturities = PortfolioApi.getMaturities();
    _unreadCount = NotificationsApi.getUnreadCount();
  }

  Future<void> _logout() async {
    await TokenStorage.clearToken();
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const MobileInputScreen(),
      ),
      (_) => false,
    );
  }

  List<dynamic> _dueSoon(List<dynamic> items) {
    return items.where((m) => m['status'] == 'DUE_SOON').toList();
  }

  void _openInsights() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PortfolioInsightsScreen(),
      ),
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

          /// 📊 Insights (explicit navigation, not inline)
          IconButton(
            icon: const Icon(Icons.insights),
            tooltip: 'Insights',
            onPressed: _openInsights,
          ),

          /// 📅 FD Maturities
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
          /// 🔹 UPCOMING FD MATURITIES
          FutureBuilder<List<dynamic>>(
            future: _maturities,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();

              final dueSoon = _dueSoon(snapshot.data!);
              if (dueSoon.isEmpty) return const SizedBox();

              return Card(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Upcoming Fixed Deposits',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.warning, color: Colors.orange),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...dueSoon.map(
                        (m) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(m['name']),
                              Text(
                                '${m['daysRemaining']} days',
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          /// 🔹 SUMMARY
          FutureBuilder<Map<String, dynamic>>(
            future: _summary,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: LinearProgressIndicator(),
                );
              }

              if (!snapshot.hasData) return const SizedBox();

              final s = snapshot.data!;
              return Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _metric('Invested', s['investedValue']),
                      _metric('Current', s['currentValue']),
                      _metric('P/L', s['pnl']),
                    ],
                  ),
                ),
              );
            },
          ),

          /// 🔹 PORTFOLIO LIST (MAIN CONTENT)
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

  Widget _metric(String label, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Text(
          '₹${(value as num).toStringAsFixed(0)}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}







