import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/portfolio_api.dart';

class AddAssetScreen extends StatefulWidget {
  const AddAssetScreen({super.key});

  @override
  State<AddAssetScreen> createState() => _AddAssetScreenState();
}

class _AddAssetScreenState extends State<AddAssetScreen> {
  final _formKey = GlobalKey<FormState>();

  String _type = 'STOCK';
  bool _isSaving = false;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _qty = TextEditingController();
  final TextEditingController _price = TextEditingController();

  bool get _manualDisabled =>
      _type == 'STOCK' || _type == 'FIXED_INCOME';

  bool get _isCash => _type == 'CASH';

  String _quantityLabel() {
    switch (_type) {
      case 'GOLD':
        return 'Weight (grams)';
      case 'REAL_ESTATE':
        return 'Property Value';
      case 'CASH':
        return 'Amount';
      default:
        return 'Quantity';
    }
  }

  double _parse(String v) =>
      double.parse(v.replaceAll(RegExp(r'[^0-9.]'), ''));

  Future<void> _save() async {
    if (_manualDisabled) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final quantity = _parse(_qty.text);

      await PortfolioApi.addAsset({
        'type': _type,
        'name': _name.text,
        // CASH: quantity = amount, price = 1
        'quantity': quantity,
        'purchasePrice': _isCash ? 1 : _parse(_price.text),
        'currency': 'INR',
      });

      if (!mounted) return;
      Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Asset')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _type,
                    items: const [
                      DropdownMenuItem(value: 'STOCK', child: Text('Stock')),
                      DropdownMenuItem(value: 'GOLD', child: Text('Gold')),
                      DropdownMenuItem(
                          value: 'FIXED_INCOME',
                          child: Text('Fixed Deposit')),
                      DropdownMenuItem(
                          value: 'REAL_ESTATE',
                          child: Text('Real Estate')),
                      DropdownMenuItem(value: 'CASH', child: Text('Cash')),
                    ],
                    onChanged: (v) {
                      setState(() {
                        _type = v!;
                        _name.clear();
                        _qty.clear();
                        _price.clear();
                      });
                    },
                    decoration:
                        const InputDecoration(labelText: 'Asset Type'),
                  ),

                  if (_manualDisabled)
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _type == 'STOCK'
                            ? 'Stocks must be imported from your broker.'
                            : 'Fixed Deposits must be imported from your bank.',
                      ),
                    ),

                  TextFormField(
                    controller: _name,
                    enabled: !_manualDisabled,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),

                  TextFormField(
                    controller: _qty,
                    enabled: !_manualDisabled,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9.]')),
                    ],
                    decoration:
                        InputDecoration(labelText: _quantityLabel()),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),

                  /// ❌ HIDE PURCHASE PRICE FOR CASH
                  if (!_isCash)
                    TextFormField(
                      controller: _price,
                      enabled: !_manualDisabled,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9.]')),
                      ],
                      decoration: InputDecoration(
                        labelText: _type == 'GOLD'
                            ? 'Purchase Price (per gram)'
                            : 'Purchase Price',
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          _isSaving || _manualDisabled ? null : _save,
                      child: const Text('Save Asset'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_isSaving)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

