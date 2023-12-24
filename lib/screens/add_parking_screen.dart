import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_parking_md/config/routes/routes.dart';
import 'package:smart_parking_md/providers/license_plate_provider.dart';
import 'package:smart_parking_md/providers/payment_method_provider.dart';
import 'package:smart_parking_md/providers/providers.dart';
import 'package:smart_parking_md/utils/utils.dart';
import 'package:smart_parking_md/widgets/widgets.dart';

class AddParking extends ConsumerWidget {
  static AddParking builder(BuildContext context, GoRouterState state) =>
      const AddParking();
  const AddParking({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colorScheme;
    final deviceSize = context.deviceSize;

    final localization = ref.watch(cityProvider);

    List<String> paymentMethods = ['SMS', 'Card'];

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          'Parcare',
          style: TextStyle(color: colors.background),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: colors.background),
        backgroundColor: colors.secondary,
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // headerPage(
              //   ref: ref,
              //   position: ref.watch(cityProvider),
              //   colors: colors,
              //   deviceSize: deviceSize,
              // ),
              customSection(
                colors: colors.secondary,
                width: deviceSize.width,
                sectionTitle: 'Plătește parcare în',
                child: InkWell(
                    onTap: () {
                      ref.context.goNamed(licensePlatesRouteName);
                    },
                    child: containerEmitInput(
                        text: localization.when(
                          data: (data) => data,
                          error: (error, stackTrace) => error.toString(),
                          loading: () => '...',
                        ),
                        width: deviceSize.width)),
              ),
              customSection(
                colors: colors.secondary,
                width: deviceSize.width,
                sectionTitle: 'Alege metoda de plată',
                child: SizedBox(
                  height: 40, // Specificați o înălțime fixă pentru ListView
                  child: ListView.builder(
                    itemCount: paymentMethods.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: InkWell(
                          onTap: () => ref
                              .read(paymentMethodProvider.notifier)
                              .state = paymentMethods[index],
                          child: reusableContainerPaymentMethod(
                            text: paymentMethods[index],
                            selected: paymentMethods[index] ==
                                    ref.watch(paymentMethodProvider)
                                ? true
                                : false,
                            color: colors.secondaryContainer,
                            fontColor: colors.onTertiary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const Gap(10),
              customSection(
                  sectionTitle: 'Numărul de înmatriculare',
                  colors: colors.background,
                  width: deviceSize.width,
                  child: Text('section 1')),
              const Gap(10),
              customSection(
                  sectionTitle: 'Selectează zona',
                  width: deviceSize.width,
                  colors: colors.background,
                  child: Text('section 2'))
            ],
          )
        ],
      ),
    );
  }
}
