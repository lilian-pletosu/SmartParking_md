import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_parking_md/providers/license_plate_provider.dart';
import 'package:smart_parking_md/providers/providers.dart';
import 'package:smart_parking_md/utils/utils.dart';

class CitiesScreen extends ConsumerWidget {
  static CitiesScreen builder(BuildContext context, GoRouterState state) =>
      const CitiesScreen();
  const CitiesScreen({super.key});

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colorScheme;
    final deviceSize = context.deviceSize;
    final availableCities = ref.watch(cityListProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          'Orașe',
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
            itemCount: availableCities.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  //
                },
                child: ListTile(
                  title: Text(
                    availableCities[index].city,
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
