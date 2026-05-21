// shop_parent_screen.dart
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'product_catalog_screen.dart';
import 'search_skincare_screen.dart';
import 'shop_settings_screen.dart';

class ShopParentScreen extends StatelessWidget {
  const ShopParentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: [
        PersistentTabConfig(
          screen: const ProductCatalogScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.storefront_outlined),
            title: 'Shop',
            activeForegroundColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        PersistentTabConfig(
          screen: const SearchSkincareScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.search),
            title: 'Search',
            activeForegroundColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        PersistentTabConfig(
          screen: const ShopSettingsScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.settings_outlined),
            title: 'Settings',
            activeForegroundColor: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) => Style2BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(
          color: Theme.of(context).colorScheme.onInverseSurface,
        ),
      ),
    );
  }
}