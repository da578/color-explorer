import 'package:color_explorer/color_explorer.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

/// The root widget of the application.
///
/// This widget configures the global application theme and sets up
/// the initial screen with manual dependency injection.
class MyApp extends StatefulWidget {
  /// Creates the root application widget.
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final ColorExplorerNotifier _colorNotifier;

  @override
  void initState() {
    super.initState();
    // Generate a detailed spectrum of 360 colors for a smooth transition.
    final detailedSpectrum = ColorTokens.generateDetailedSpectrum(
      360,
    );
    _colorNotifier = ColorExplorerNotifier(
      initialColors: detailedSpectrum,
    );
  }

  @override
  void dispose() {
    _colorNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _colorNotifier,
    builder: (_, _) => MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Color Explorer',
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _colorNotifier.activeColor,
          brightness: Brightness.dark,
        ),
      ),
      home: ColorExplorerScreen(
        notifier: _colorNotifier,
      ),
    ),
  );
}
