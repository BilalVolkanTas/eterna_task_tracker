import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../providers/app_providers.dart';

// Her alışkanlığa özel Saat, Dakika ve Saniye seçimi sunan diyalog.
class AddHabitDialog extends ConsumerStatefulWidget {
  const AddHabitDialog({super.key});

  @override
  ConsumerState<AddHabitDialog> createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends ConsumerState<AddHabitDialog> {
  final _titleController = TextEditingController();
  final _hoursController = TextEditingController(text: '0');
  final _minutesController = TextEditingController(text: '0');
  final _secondsController = TextEditingController(text: '10');

  int _selectedIconCode = Icons.water_drop_rounded.codePoint;

  final List<IconData> _availableIcons = [
    Icons.water_drop_rounded,
    Icons.menu_book_rounded,
    Icons.fitness_center_rounded,
    Icons.directions_run_rounded,
    Icons.self_improvement_rounded,
    Icons.code_rounded,
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _hoursController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  Widget _buildTimeInput({
    required String label,
    required TextEditingController controller,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Yeni Alışkanlık Ekle',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Alışkanlık Adı (Örn: Su İç)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'İkon Seçin:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _availableIcons.map((icon) {
                  final isSelected = _selectedIconCode == icon.codePoint;
                  return InkWell(
                    onTap: () =>
                        setState(() => _selectedIconCode = icon.codePoint),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: isSelected ? Colors.white : Colors.grey,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text(
                'Hatırlatma Sıklığı:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildTimeInput(label: 'Saat', controller: _hoursController),
                  const SizedBox(width: 8),
                  _buildTimeInput(
                    label: 'Dakika',
                    controller: _minutesController,
                  ),
                  const SizedBox(width: 8),
                  _buildTimeInput(
                    label: 'Saniye',
                    controller: _secondsController,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Alışkanlığı Kaydet',
                  onPressed: () {
                    if (_titleController.text.trim().isNotEmpty) {
                      final hours = int.tryParse(_hoursController.text) ?? 0;
                      final minutes =
                          int.tryParse(_minutesController.text) ?? 0;
                      final seconds =
                          int.tryParse(_secondsController.text) ?? 10;

                      // Toplam saniye cinsinden değeri veya dominasyon birimini belirleyelim
                      int finalValue = seconds;
                      String finalUnit = 'Saniye';

                      if (hours > 0) {
                        finalValue = hours;
                        finalUnit = 'Saat';
                      } else if (minutes > 0) {
                        finalValue = minutes;
                        finalUnit = 'Dakika';
                      }

                      ref
                          .read(habitListProvider.notifier)
                          .addHabit(
                            title: _titleController.text.trim(),
                            iconCode: _selectedIconCode,
                            reminderValue: finalValue,
                            reminderUnit: finalUnit,
                          );
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
