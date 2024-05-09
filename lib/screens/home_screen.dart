import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_parking_md/providers/providers.dart';
import 'package:smart_parking_md/utils/utils.dart';

class HomeScreen extends ConsumerWidget {
  static HomeScreen builder(BuildContext context, GoRouterState state) =>
      const HomeScreen();

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colorScheme;
    final deviceSize = context.deviceSize;

    return Scaffold(
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Drawer Header'),
              ),
              ListTile(
                title: const Text('Item 1'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: const Text('Item 2'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ),
        backgroundColor: colors.background,
        appBar: buildAppBar(context, ref),
        body: Stack(
          children: [
            Column(
              children: [
                // Header
                Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, left: 15, right: 15),
                  child: header(deviceSize, colors, context),
                ),
                // Body
                Expanded(
                    child: bodyWidget(colors, context, deviceSize, ref: ref))
              ],
            )
          ],
        ));
  }

  Container bodyWidget(ColorScheme colors, BuildContext context, deviceSize,
      {required WidgetRef ref}) {
    return Container(
      decoration: BoxDecoration(color: colors.onBackground),
      width: deviceSize.width,
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTile(
            context: context,
            deviceSize: deviceSize,
            title: 'Mașinile tale',
            colors: colors,
            child: myCars(
              context: context,
              deviceSize: deviceSize,
              colors: colors,
            ),
          ),
          const Gap(15),
          sectionTile(
            context: context,
            deviceSize: deviceSize,
            title: 'Ultimile parcări',
            colors: colors,
            child: lastParcs(
              context: context,
              deviceSize: deviceSize,
              colors: colors,
              ref: ref,
            ),
          )
        ],
      ),
    );
  }

  Widget sectionTile({
    required String title,
    required Widget child,
    required ColorScheme colors,
    required BuildContext context,
    required deviceSize,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 25,
                color: colors.primary,
                fontFamily: context.textTheme.toString(),
                fontWeight: FontWeight.w600)),
        const Gap(10),
        Container(height: deviceSize.height * 0.2, child: child)
      ],
    );
  }

  Widget myCars({
    required BuildContext context,
    required deviceSize,
    required ColorScheme colors,
  }) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(right: 10),
          width: deviceSize.width * 0.4,
          decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.directions_car,
                color: colors.onBackground,
                size: 50,
              ),
              const Gap(10),
              Text('Audi A4',
                  style: TextStyle(
                      fontSize: 20,
                      color: colors.onBackground,
                      fontFamily: context.textTheme.toString(),
                      fontWeight: FontWeight.w500)),
              const Gap(5),
              Text('A 1234 AA',
                  style: TextStyle(
                      fontSize: 15,
                      color: colors.onBackground,
                      fontFamily: context.textTheme.toString(),
                      fontWeight: FontWeight.w300)),
            ],
          ),
        );
      },
    );
  }

  Widget lastParcs({
    required BuildContext context,
    required deviceSize,
    required ColorScheme colors,
    required WidgetRef ref,
  }) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(right: 10),
          width: deviceSize.width * 0.6,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: colors.primary, width: 1),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('str. Mihai Eminescu',
                      style: TextStyle(
                          fontSize: 20,
                          color: colors.primary,
                          fontFamily: context.textTheme.toString(),
                          fontWeight: FontWeight.w600)),
                  Icon(
                    Icons.keyboard_arrow_right_outlined,
                    color: colors.primary,
                  )
                ],
              ),
              Text('3,5 km - 12 lei/h',
                  style: TextStyle(
                      fontSize: 20,
                      color: colors.background,
                      fontFamily: context.textTheme.toString(),
                      fontWeight: FontWeight.w500)),
              const Gap(5),
              mapWidget(ref: ref),
            ],
          ),
        );
      },
    );
  }

  Widget mapWidget({required WidgetRef ref}) {
    final currentPosition = ref.watch(currentPositionProvider);

    // Check if the current position is still the initial position
    if (currentPosition.latitude == 0 && currentPosition.longitude == 0) {
      // If it is, show a loading indicator
      return const Center(child: CircularProgressIndicator());
    } else {
      // If not, show the GoogleMap
      return Flexible(
        child: GoogleMap(
          mapType: MapType.terrain,
          initialCameraPosition: CameraPosition(
            target: LatLng(currentPosition.latitude, currentPosition.longitude),
            zoom: 17.4746,
          ),
          trafficEnabled: true,
          scrollGesturesEnabled: false,
          zoomGesturesEnabled: false,
          tiltGesturesEnabled: false,
          markers: {
            Marker(
              markerId: MarkerId('Parcare'),
              position:
                  LatLng(currentPosition.latitude, currentPosition.longitude),
            ),
          },
          zoomControlsEnabled: false,
        ),
      );
    }
  }

  Container header(deviceSize, ColorScheme colors, BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
            top: deviceSize.height * 0.03, bottom: deviceSize.height * 0.03),
        width: deviceSize.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Caută loc de parcare',
              style: TextStyle(
                  fontSize: deviceSize.height * 0.04,
                  color: colors.onBackground,
                  fontFamily: context.textTheme.toString(),
                  fontWeight: FontWeight.w700),
            ),
            const Gap(10),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: deviceSize.height * 0.05,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        hintText: 'Caută parcare...',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const Gap(10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: colors.onBackground,
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(
                    Icons.my_location_outlined,
                    color: colors.background,
                  ),
                )
              ],
            )
          ],
        ));
  }

  AppBar buildAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      leadingWidth: context.deviceSize.width * 0.9,
      toolbarHeight: context.deviceSize.height * 0.08,
      actions: [
        Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.person),
            color: context.colorScheme.onBackground,
          ),
        ),
      ],
      leading: Container(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Locația ta',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: context.textTheme.toString(),
                      color: context.colorScheme.onBackground),
                  softWrap: false,
                ),
                const Icon(Icons.arrow_drop_down)
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.location_on_sharp,
                  color: context.colorScheme.onBackground,
                ),
                const Gap(8),
                Text(
                  ref.watch(selectedCityProvider)?.city ?? '--',
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: context.textTheme.toString(),
                    color: context.colorScheme.onBackground,
                    fontWeight: FontWeight.w300,
                  ),
                )
              ],
            )
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
