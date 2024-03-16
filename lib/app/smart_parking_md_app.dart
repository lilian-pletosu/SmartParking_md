import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_parking_md/config/config.dart';
import 'package:smart_parking_md/config/routes/routes.dart';
import 'package:permission_handler/permission_handler.dart';

class SmartParkingApp extends ConsumerWidget {
  const SmartParkingApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerConfig = ref.watch(routersProvider);
    requestLocationPermission();
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: routerConfig,
    );
  }

  Future<void> requestLocationPermission() async {
    await Permission.location.request();
  }
}
