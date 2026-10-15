import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/custom_app_bar.dart';
import '../../providers/app_providers.dart';

// Temiz ve sadeleştirilmiş ayarlar ekranı.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(darkModeProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Ayarlar'),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 1,
            child: SwitchListTile(
              title: const Text(
                'Karanlık Mod',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              value: isDarkMode,
              onChanged: (_) =>
                  ref.read(darkModeProvider.notifier).toggleTheme(),
            ),
          ),
        ],
      ),
    );
  }
}
