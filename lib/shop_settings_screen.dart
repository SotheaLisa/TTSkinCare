// shop_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_logic.dart';
import 'layout_config_logic.dart';

class ShopSettingsScreen extends StatelessWidget {
  const ShopSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final config = context.watch<LayoutConfigLogic>();
    final cart = context.watch<CartLogic>();
    const avatarUrl =
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=300';

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: CircleAvatar(
              radius: 64,
              backgroundImage: const NetworkImage(avatarUrl),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text('Skincare Enthusiast',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
          const SizedBox(height: 16),
          const Divider(),
          // Dark mode
          Card(
            child: ListTile(
              leading: const Icon(Icons.lightbulb_outline),
              title: Text(
                  'Switch to ${config.dark ? "Light" : "Dark"} Mode'),
              trailing:
                  Icon(config.dark ? Icons.dark_mode : Icons.light_mode),
              onTap: () => context.read<LayoutConfigLogic>().toggleDark(),
            ),
          ),
          // Grid/List toggle
          Card(
            child: ListTile(
              leading: const Icon(Icons.style_outlined),
              title: Text(
                  'Switch to ${config.isGridStyle ? "List" : "Grid"} Style'),
              trailing: Icon(
                  config.isGridStyle ? Icons.grid_view : Icons.list),
              onTap: () =>
                  context.read<LayoutConfigLogic>().toggleStyle(),
            ),
          ),
          const Divider(),
          // Cart summary
          Card(
            child: ListTile(
              leading: const Icon(Icons.shopping_bag_outlined),
              title: Text('Cart — ${cart.totalCount} item(s)'),
              subtitle:
                  Text('Total: \$${cart.totalPrice.toStringAsFixed(2)}'),
              trailing: cart.items.isNotEmpty
                  ? TextButton(
                      onPressed: () {
                        context.read<CartLogic>().clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Cart cleared')),
                        );
                      },
                      child: const Text('Clear'),
                    )
                  : null,
            ),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Version'),
            trailing: Text('1.0.0'),
          ),
        ],
      ),
    );
  }
}