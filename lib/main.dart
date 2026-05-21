import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_logic.dart';
import 'layout_config_logic.dart';
import 'shop_parent_screen.dart';

void main() {
  // Catches ALL uncaught Flutter/Dart errors and prints them
  // so you can see exactly what crashes instead of a silent stop.
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      debugPrint('=== FLUTTER ERROR ===');
      debugPrint(details.exceptionAsString());
      debugPrint(details.stack.toString());
    };
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LayoutConfigLogic()),
          ChangeNotifierProvider(create: (_) => CartLogic()),
        ],
        child: const SkincareApp(),
      ),
    );
  }, (error, stack) {
    debugPrint('=== ZONE ERROR ===');
    debugPrint(error.toString());
    debugPrint(stack.toString());
  });
}

class SkincareApp extends StatelessWidget {
  const SkincareApp({super.key});

  @override
  Widget build(BuildContext context) {
    final config = context.watch<LayoutConfigLogic>();

    return MaterialApp(
      title: 'TTSkincare Shop',
      debugShowCheckedModeBanner: false,
      themeMode: config.dark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE8A0BF),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE8A0BF),
          brightness: Brightness.dark,
        ),
      ),
      home: const ShopParentScreen(),
    );
  }
}