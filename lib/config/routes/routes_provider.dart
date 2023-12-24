import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_parking_md/config/routes/routes.dart';

final routersProvider = Provider<GoRouter>((ref) {
  return GoRouter(
      initialLocation: homePageRoutePath,
      navigatorKey: nagivationKey,
      routes: appRoutes);
});
