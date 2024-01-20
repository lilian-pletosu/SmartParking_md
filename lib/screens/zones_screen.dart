import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_parking_md/providers/providers.dart';
import 'package:smart_parking_md/utils/utils.dart';

class ZonesScreen extends ConsumerWidget {
  static ZonesScreen builder(BuildContext context, GoRouterState state) =>
      const ZonesScreen();
  const ZonesScreen({super.key});

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colorScheme;
    // final deviceSize = context.deviceSize;
    // final city = ref.watch(cityProvider).when(
    //       data: (data) => data,
    //       error: (error, stackTrace) => error,
    //       loading: () => '...',
    //     );

    // final cityDb = ref
    //     .watch(cityListProvider.notifier)
    //     .loadCities()
    //     .then((value) => ref.watch(zoneProvider.notifier).getZones(value));
    final zones = ref.watch(zoneProvider);
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          'Zonele',
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
            itemCount: zones.length,
            itemBuilder: (context, index) {
              return zones.isEmpty
                  ? Text('Nu sunt zone')
                  : ListTile(
                      title: InkWell(
                        onTap: () {
                          ref.watch(selectedZoneProvider.notifier).state =
                              zones[index];
                          context.pop();
                        },
                        child: Text(
                          zones[index].name,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      subtitle: Text(' 1 oră - ${zones[index].tarif} MDL'),
                    );
            },
          )
        ],
      ),
    );
  }
}
