import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ShopSettingsScreen extends StatefulWidget {
  const ShopSettingsScreen({super.key});

  @override
  State<ShopSettingsScreen> createState() =>
      _ShopSettingsScreenState();
}

class _ShopSettingsScreenState
    extends State<ShopSettingsScreen> {

  final shopNameController =
      TextEditingController();

  final addressController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    final settingsBox = Hive.box('settings');

    shopNameController.text =
        settingsBox.get('shopName', defaultValue: '');

    addressController.text =
        settingsBox.get('shopAddress', defaultValue: '');

    phoneController.text =
        settingsBox.get('shopPhone', defaultValue: '');
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: shopNameController,
              decoration: const InputDecoration(
                labelText: 'Shop Name',
              ),
            ),

            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
              ),
            ),

            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {

                final settingsBox =
                    Hive.box('settings');

                settingsBox.put(
                  'shopName',
                  shopNameController.text,
                );

                settingsBox.put(
                  'shopAddress',
                  addressController.text,
                );

                settingsBox.put(
                  'shopPhone',
                  phoneController.text,
                );

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content:
                        Text('Settings Saved'),
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}