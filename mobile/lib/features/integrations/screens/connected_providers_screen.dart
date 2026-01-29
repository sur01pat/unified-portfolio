import 'package:flutter/material.dart';
import '../services/providers_api.dart';

class ConnectedProvidersScreen extends StatefulWidget {
  const ConnectedProvidersScreen({super.key});

  @override
  State<ConnectedProvidersScreen> createState() =>
      _ConnectedProvidersScreenState();
}

class _ConnectedProvidersScreenState
    extends State<ConnectedProvidersScreen> {
  late Future<List<dynamic>> _consents;
  late Future<List<dynamic>> _jobs;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _consents = ProvidersApi.getConsents();
    _jobs = ProvidersApi.getSyncJobs();
  }

  /// ✅ Pick ACTIVE consent if present, else latest by grantedAt
  dynamic _latestConsentFor(
    List<dynamic> consents,
    String providerId,
  ) {
    final providerConsents = consents
        .where((c) => c['providerId'] == providerId)
        .toList();

    if (providerConsents.isEmpty) return null;

    final active = providerConsents
        .where((c) => c['status'] == 'ACTIVE')
        .toList();

    if (active.isNotEmpty) return active.first;

    providerConsents.sort(
      (a, b) =>
          b['grantedAt'].compareTo(a['grantedAt']),
    );

    return providerConsents.first;
  }

  dynamic _lastJobFor(
    List<dynamic> jobs,
    String providerId,
  ) {
    final filtered = jobs
        .where((j) => j['providerId'] == providerId)
        .toList();

    if (filtered.isEmpty) return null;

    filtered.sort(
      (a, b) =>
          b['startedAt'].compareTo(a['startedAt']),
    );

    return filtered.first;
  }

  void _showError(Object e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const providerId = 'mock-aa';

    return Scaffold(
      appBar: AppBar(title: const Text('Connected Providers')),
      body: FutureBuilder(
        future: Future.wait([_consents, _jobs]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final consents = snapshot.data![0];
          final jobs = snapshot.data![1];

          final consent =
              _latestConsentFor(consents, providerId);
          final job = _lastJobFor(jobs, providerId);

          final consentStatus =
              consent == null ? 'NO CONSENT' : consent['status'];

          final canSync =
              consent != null && consent['status'] == 'ACTIVE';

          return Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mock Account Aggregator',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Consent: $consentStatus'),
                  Text(
                    'Last sync: ${job?['status'] ?? 'NEVER'}',
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      if (!canSync)
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await ProvidersApi
                                  .grantConsent(providerId);
                              setState(_reload);
                            } catch (e) {
                              _showError(e);
                            }
                          },
                          child:
                              const Text('Grant Consent'),
                        ),

                      if (canSync)
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await ProvidersApi
                                  .revokeConsent(consent['id']);
                              setState(_reload);
                            } catch (e) {
                              _showError(e);
                            }
                          },
                          child:
                              const Text('Revoke Consent'),
                        ),

                      const SizedBox(width: 12),

                      ElevatedButton(
                        onPressed: canSync
                            ? () async {
                                try {
                                  await ProvidersApi
                                      .sync(providerId);
                                  setState(_reload);
                                } catch (e) {
                                  _showError(e);
                                }
                              }
                            : null,
                        child: const Text('Sync Now'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


