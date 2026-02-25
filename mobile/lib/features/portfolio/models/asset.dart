enum AssetSource {
  MANUAL,
  BANK,
  BROKER,
}

AssetSource? assetSourceFromJson(String? v) {
  if (v == null) return null;
  return AssetSource.values
      .firstWhere((e) => e.name == v);
}

class Asset {
  final String id;
  final String type;
  final String name;
  final double quantity;
  final double purchasePrice;
  final String currency;
  final String? country;
  final String? sector;
  final String? platform;      // ✅ ADD
  final AssetSource? source; // ✅ NEW
  

  Asset({
    required this.id,
    required this.type,
    required this.name,
    required this.quantity,
    required this.purchasePrice,
    required this.currency,
    this.country,
    this.sector,
    this.platform,             // ✅ ADD
    this.source,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'],
      type: json['type'],
      name: json['name'],
      quantity: (json['quantity'] as num).toDouble(),
      purchasePrice:
          (json['purchasePrice'] as num).toDouble(),
      currency: json['currency'],
      country: json['country'],
      sector: json['sector'],
      //platform: json['platform'],
      source: assetSourceFromJson(json['source']),
    );
  }
}

