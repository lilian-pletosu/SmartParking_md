import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_parking_md/config/routes/routes.dart';
import 'package:smart_parking_md/screens/screens.dart';

// ... Importuri ...

final nagivationKey = GlobalKey<NavigatorState>();

final appRoutes = [
  GoRoute(
      name: homePageRouteName,
      path: homePageRoutePath,
      parentNavigatorKey: nagivationKey,
      builder: HomeScreen.builder,
      routes: [
        GoRoute(
          name: addParkingRouteName,
          path: addParkingRoutePath,
          parentNavigatorKey: nagivationKey,
          // builder: AddParking.builder,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const AddParking(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const Offset slideBegin = Offset(0.0, 1.0);
                const Offset slideEnd = Offset(0.0, 0.0);
                var tween = Tween(begin: slideBegin, end: slideEnd);
                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 200),
            );
          },
          routes: [
            GoRoute(
              name: licensePlatesRouteName,
              path: licensePlatesRoutePath,
              parentNavigatorKey: nagivationKey,
              builder: LicensePlates.builder,
              pageBuilder: (context, state) {
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: const LicensePlates(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const Offset slideBegin = Offset(0.0, 1.0);
                    const Offset slideEnd = Offset(0.0, 0.0);
                    var tween = Tween(begin: slideBegin, end: slideEnd);
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 200),
                );
              },
            ),
          ],
        )
      ]),
];
