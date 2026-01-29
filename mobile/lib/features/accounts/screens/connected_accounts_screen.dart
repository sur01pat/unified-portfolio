import 'package:flutter/material.dart';
import '../services/accounts_api.dart';

class ConnectedAccountsScreen extends StatefulWidget {
  const ConnectedAccountsScreen({super.key});

  @override
  State<ConnectedAccountsScreen> createState() =>
      _ConnectedAccountsScreenState();
}

class _ConnectedAccountsScreenState
    extends State<ConnectedAccountsScreen> {
  late Future<List<dynamic>> _accounts;

  /// Track syncing state per account (V2.1 mock)
  final Set<String> _syncingAccounts = {};

  /// Track disconnected accounts locally (V2.1 mock)
  final Set<String> _disconnectedAccounts = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _accounts = AccountsApi.getAccounts();
  }

  Future<void> _seed() async {
    await AccountsApi.seedAccounts();
    setState(_load);
  }

  String _accountKey(dynamic acc) =>
      '${acc['institutionType']}-${acc['accountNumberMasked']}';

  Future<void> _sync(dynamic acc) async {
    final id = _accountKey(acc);

    if (_disconnectedAccounts.contains(id)) return;

    setState(() {
      _syncingAccounts.add(id);
    });

    try {
      if (acc['status'] == 'ERROR') {
        await Future.delayed(const Duration(seconds: 1));
        throw Exception('Sync failed');
      }

      if (acc['institutionType'] == 'BANK') {
        await AccountsApi.syncBank();
      } else {
        await AccountsApi.syncBroker();
      }

      /// 👇 Demo delay so spinner is visible
      await Future.delayed(const Duration(seconds: 1));
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Failed to sync ${acc['accountName']}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _syncingAccounts.remove(id);
        _load();
      });
    }
  }

  Future<void> _disconnect(dynamic acc) async {
    final id = _accountKey(acc);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Disconnect account?'),
        content: Text(
          'Disconnecting "${acc['accountName']}" will stop future syncs.\n\n'
          'Your existing assets will remain visible as read-only history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Disconnect',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _disconnectedAccounts.add(id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('${acc['accountName']} disconnected'),
      ),
    );
  }

  Color _statusColor(String status, bool disconnected) {
    if (disconnected) return Colors.grey;
    switch (status) {
      case 'ACTIVE':
        return Colors.green;
      case 'ERROR':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  IconData _icon(String type) {
    return type == 'BANK'
        ? Icons.account_balance
        : Icons.trending_up;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connected Accounts')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _seed,
        icon: const Icon(Icons.add),
        label: const Text('Add mock accounts'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _accounts,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final accounts = snapshot.data!;
          if (accounts.isEmpty) {
            return const Center(
              child: Text('No connected accounts'),
            );
          }

          return ListView.builder(
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final a = accounts[index];
              final id = _accountKey(a);
              final isSyncing =
                  _syncingAccounts.contains(id);
              final isDisconnected =
                  _disconnectedAccounts.contains(id);

              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      /// ICON
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Icon(
                          _icon(a['institutionType']),
                          size: 28,
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// MAIN CONTENT
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              a['accountName'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '**** ${a['accountNumberMasked']}',
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isDisconnected
                                  ? 'Disconnected'
                                  : a['lastSyncedAt'] !=
                                          null
                                      ? 'Last synced: ${a['lastSyncedAt']}'
                                      : 'Never synced',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// STATUS + ACTIONS
                      Column(
                        children: [
                          Text(
                            isDisconnected
                                ? 'DISCONNECTED'
                                : a['status'],
                            style: TextStyle(
                              color: _statusColor(
                                  a['status'],
                                  isDisconnected),
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          isSyncing
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : OutlinedButton(
                                  onPressed:
                                      isDisconnected
                                          ? null
                                          : () =>
                                              _sync(a),
                                  child:
                                      const Text('Sync'),
                                ),
                          TextButton(
                            onPressed: isDisconnected
                                ? null
                                : () => _disconnect(a),
                            child: const Text(
                              'Disconnect',
                              style: TextStyle(
                                  color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}



