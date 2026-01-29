import 'dart:async';
import 'package:flutter/material.dart';
import '../models/asset.dart'; // includes AssetSource
import '../services/portfolio_api.dart';
import 'add_asset_screen.dart';

class PortfolioListScreen extends StatefulWidget {
  final VoidCallback onChanged;

  const PortfolioListScreen({super.key, required this.onChanged});

  @override
  State<PortfolioListScreen> createState() =>
      _PortfolioListScreenState();
}

class _PortfolioListScreenState extends State<PortfolioListScreen> {
  late Future<List<Asset>> _assets;
  Timer? _refreshTimer;
  DateTime _lastUpdated = DateTime.now();

  Asset? _lastDeleted;

  @override
  void initState() {
    super.initState();
    _loadAssets();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onChanged();
    });

    _refreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _refresh(),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _loadAssets() {
    _assets = PortfolioApi.getAssets();
  }

  void _refresh() {
    if (!mounted) return;

    setState(() {
      _loadAssets();
      _lastUpdated = DateTime.now();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onChanged();
    });
  }

  /// 🔑 DELETE RULE: ONLY MANUAL ASSETS
  bool _isDeletable(Asset a) {
    return a.source == AssetSource.MANUAL;
  }

  /// 🔒 LOCK ICON FOR NON-DELETABLE ASSETS
  Widget _lockIcon(Asset a) {
    if (_isDeletable(a)) return const SizedBox.shrink();

    final reason = a.source == AssetSource.BANK
        ? 'Synced from bank'
        : a.source == AssetSource.BROKER
            ? 'Synced from broker'
            : 'System managed';

    return Tooltip(
      message: reason,
      child: const Icon(
        Icons.lock,
        size: 16,
        color: Colors.grey,
      ),
    );
  }

  Future<void> _addAsset() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddAssetScreen()),
    );
    _refresh();
  }

  Future<void> _deleteAsset(Asset asset) async {
    _lastDeleted = asset;
    await PortfolioApi.deleteAsset(asset.id);
    _refresh();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${asset.name} deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: _undoDelete,
        ),
      ),
    );
  }

  Future<void> _undoDelete() async {
    if (_lastDeleted == null) return;

    final a = _lastDeleted!;
    _lastDeleted = null;

    await PortfolioApi.addAsset({
      'type': a.type,
      'name': a.name,
      'quantity': a.quantity,
      'purchasePrice': a.purchasePrice,
      'currency': a.currency,
      'country': a.country,
      'sector': a.sector,
      'source': a.source?.name,
    });

    _refresh();
  }

  Map<String, List<Asset>> _groupByType(List<Asset> assets) {
    final Map<String, List<Asset>> grouped = {};
    for (final a in assets) {
      grouped.putIfAbsent(a.type, () => []).add(a);
    }
    return grouped;
  }

  double _assetValue(Asset a) =>
      a.quantity * a.purchasePrice;

  double _sectionTotal(List<Asset> assets) {
    return assets.fold(
      0,
      (sum, a) => sum + _assetValue(a),
    );
  }

  double _portfolioTotal(List<Asset> assets) {
    return assets.fold(
      0,
      (sum, a) => sum + _assetValue(a),
    );
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'STOCK':
        return 'Equity';
      case 'GOLD':
        return 'Gold';
      case 'CASH':
        return 'Cash';
      case 'REAL_ESTATE':
        return 'Real Estate';
      case 'FIXED_INCOME':
        return 'Fixed Income';
      default:
        return type;
    }
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'STOCK':
        return Colors.blue;
      case 'GOLD':
        return Colors.amber;
      case 'CASH':
        return Colors.green;
      case 'REAL_ESTATE':
        return Colors.brown;
      case 'FIXED_INCOME':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  Widget _percentageBar(double percent, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: LinearProgressIndicator(
        value: percent / 100,
        minHeight: 8,
        backgroundColor: Colors.grey.shade300,
        valueColor: AlwaysStoppedAnimation(color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _addAsset,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Last updated: ${_lastUpdated.toLocal().toString().substring(11, 19)}',
              style:
                  const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Asset>>(
              future: _assets,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style:
                          const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                final assets = snapshot.data!;
                if (assets.isEmpty) {
                  return const Center(child: Text('No assets'));
                }

                final totalPortfolio =
                    _portfolioTotal(assets);
                final grouped = _groupByType(assets);

                return ListView(
                  children: grouped.entries.map((entry) {
                    final sectionValue =
                        _sectionTotal(entry.value);
                    final percentage =
                        totalPortfolio == 0
                            ? 0
                            : (sectionValue /
                                    totalPortfolio *
                                    100);

                    return Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                children: [
                                  Text(
                                    _typeLabel(entry.key),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '₹${sectionValue.toStringAsFixed(0)} '
                                    '(${percentage.toStringAsFixed(0)}%)',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              _percentageBar(
                                percentage.toDouble(),
                                _typeColor(entry.key),
                              ),
                            ],
                          ),
                        ),
                        ...entry.value.map((a) {
                          final invested = _assetValue(a);

                          final tile = Card(
                            margin:
                                const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4),
                            child: ListTile(
                              title: Text(a.name),
                              subtitle: Text(
                                a.type == 'GOLD'
                                    ? '${a.quantity} g @ ₹${a.purchasePrice}/g'
                                    : '${a.quantity} units',
                              ),
                              trailing: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '₹${invested.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                        fontWeight:
                                            FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  _lockIcon(a),
                                ],
                              ),
                            ),
                          );

                          return _isDeletable(a)
                              ? Dismissible(
                                  key: ValueKey(a.id),
                                  direction:
                                      DismissDirection
                                          .endToStart,
                                  background: Container(
                                    color: Colors.red,
                                    alignment:
                                        Alignment.centerRight,
                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                                horizontal:
                                                    20),
                                    child: const Icon(
                                        Icons.delete,
                                        color:
                                            Colors.white),
                                  ),
                                  onDismissed: (_) =>
                                      _deleteAsset(a),
                                  child: tile,
                                )
                              : tile;
                        }),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}








