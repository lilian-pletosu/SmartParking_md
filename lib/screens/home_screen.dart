import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_parking_md/providers/providers.dart';
import 'package:smart_parking_md/utils/utils.dart';
import 'package:smart_parking_md/widgets/widgets.dart';

class HomeScreen extends ConsumerWidget {
  static HomeScreen builder(BuildContext context, GoRouterState state) =>
      const HomeScreen();

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colorScheme;
    final deviceSize = context.deviceSize;

    return Scaffold(
        backgroundColor: colors.background,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                      width: deviceSize.width,
                      height: deviceSize.height * 0.3,
                      child: Image.asset(
                        'assets/images/full_logo.png',
                        opacity: const AlwaysStoppedAnimation(.8),
                      )),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      reusableItem(
                          context: context,
                          deviceSize: deviceSize,
                          title: 'Parcare',
                          colors: colors),
                      const Gap(10),
                      reusableItem(
                          title: 'Amenzi',
                          context: context,
                          deviceSize: deviceSize,
                          colors: colors)
                    ],
                  ),
                ))
              ],
            )
          ],
        ));
  }
}
