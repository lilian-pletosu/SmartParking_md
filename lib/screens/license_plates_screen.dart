import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_parking_md/providers/license_plate_provider.dart';
import 'package:smart_parking_md/utils/utils.dart';

class LicensePlates extends ConsumerWidget {
  static LicensePlates builder(BuildContext context, GoRouterState state) =>
      const LicensePlates();
  const LicensePlates({super.key});

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colorScheme;
    // final deviceSize = context.deviceSize;
    final licensePlates = ref.watch(licensePlateProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          'Numere de înmatriculare',
          style: TextStyle(color: colors.background),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: colors.background),
        backgroundColor: colors.secondary,
      ),
      body: Stack(
        children: [
          // Example: Displaying a list of license plates
          ListView.builder(
            itemCount: licensePlates.length,
            itemBuilder: (context, index) {
              return ListTile(
                trailing: InkWell(
                  onTap: () => ref
                      .watch(licensePlateProvider.notifier)
                      .remove(licensePlates[index])
                      .then((value) {
                        HapticFeedback.vibrate();
                        ref.refresh(selectedLicenseProvider);}),
                  child: const Icon(Icons.delete_outline_rounded),
                ),
                title: InkWell(
                  onTap: () {
                    ref
                        .watch(licensePlateProvider.notifier)
                        .updateSelectedLicense(licensePlates[index]);
                    ref.watch(selectedLicenseProvider.notifier).state =
                        licensePlates[index].licensePlate;
                    context.pop();
                  },
                  child: Text(
                    licensePlates[index].licensePlate,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
