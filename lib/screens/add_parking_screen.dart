import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pay/pay.dart';
import 'package:smart_parking_md/config/routes/routes.dart';
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
    var city = ref.watch(selectedCityProvider);

    List<String> paymentMethods = ['SMS', 'Card'];

    const _paymentItems = [
      PaymentItem(
        label: 'Total',
        amount: '50.00',
        status: PaymentItemStatus.final_price,
      )
    ];

    const String defaultGooglePay = '''{
  "provider": "google_pay",
  "data": {
    "environment": "TEST",
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "allowedPaymentMethods": [
      {
        "type": "CARD",
        "tokenizationSpecification": {
          "type": "PAYMENT_GATEWAY",
          "parameters": {
            "gateway": "example",
            "gatewayMerchantId": "gatewayMerchantId"
          }
        },
        "parameters": {
          "allowedCardNetworks": ["VISA", "MASTERCARD"],
          "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
          "billingAddressRequired": true,
          "billingAddressParameters": {
            "format": "FULL",
            "phoneNumberRequired": true
          }
        }
      }
    ],
    "merchantInfo": {
      "merchantId": "01234567890123456789",
      "merchantName": "Example Merchant Name"
    },
    "transactionInfo": {
      "countryCode": "US",
      "currencyCode": "USD"
    }
  }
}''';

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              customSection(
                colors: colors.secondary,
                width: deviceSize.width,
                sectionTitle: 'Plătește parcare în',
                child: InkWell(
                    onTap: () {
                      ref.context.goNamed(citiesRouteName);
                    },
                    child: containerEmitInput(
                        text: city?.city ?? 'Selectează un oraș',
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
                textColor: colors.secondary,
                width: deviceSize.width,
                child: Row(
                  children: [
                    Expanded(
                      flex: 9,
                      child: InkWell(
                        onTap: () => context.goNamed(licensePlatesRouteName),
                        child: containerEmitInput(
                            lead: const ImageIcon(
                                AssetImage('assets/icons/license_number.png'),
                                size: 24.0),
                            text: ref.watch(selectedLicenseProvider) ??
                                'Selecteză un număr'),
                      ),
                    ),
                    const Gap(5),
                    Expanded(
                        flex: 1,
                        child: InkWell(
                            onTap: () => _showAlertDialog(context, ref),
                            child: containerEmitInput(
                                text: '+', textCenter: true)))
                  ],
                ),
              ),
              const Gap(10),
              customSection(
                sectionTitle: 'Selectează zona și perioada',
                textColor: colors.secondary,
                width: deviceSize.width,
                colors: colors.background,
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: InkWell(
                        onTap: () => context.goNamed(zonesRouteName),
                        child: containerEmitInput(
                          lead: const Icon(Icons.location_on_outlined),
                          iconColor: colors.secondary,
                          text: ref.watch(selectedZoneProvider) != null
                              ? ref.watch(selectedZoneProvider)?.name
                              : 'Selectează zona',
                        ),
                      ),
                    ),
                    const Gap(5),
                    Expanded(
                        flex: 3,
                        child: InkWell(
                          onTap: () => _showCupertinoPicker(context, ref),
                          child: containerEmitInput(
                              text: Helpers.checkIfParkingTimeIsSet(
                                  parkingPeriod:
                                      ref.watch(parkingPeriodProvider)),
                              // text: ref.watch(parkingPeriodProvider) == '30'
                              //     ? '${ref.watch(parkingPeriodProvider)} min'
                              //     : '${ref.watch(parkingPeriodProvider)} h',--:--
                              textCenter: true),
                        ))
                  ],
                ),
              ),
            ],
          ),
          if (ref.watch(totalForParkingProvider) != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Column(
                children: [
                  Text(
                      'Total pentru parcare: ${ref.watch(totalForParkingProvider)}'),
                  GooglePayButton(
                    paymentConfiguration:
                        PaymentConfiguration.fromJsonString(defaultGooglePay),
                    paymentItems: _paymentItems,
                    type: GooglePayButtonType.pay,
                    margin: const EdgeInsets.only(top: 15.0),
                    onPaymentResult: onGooglePayResult,
                    loadingIndicator: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void onGooglePayResult(paymentResult) {
    print(paymentResult);
  }

  void _showAlertDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController textEditingController = TextEditingController();
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Adaugă un număr de înmatriculare'),
        content: Column(
          children: [
            const Text(
                'Numărul de înmatriculare trebuie sa conțină minimum 4 caractere.'),
            const Gap(5),
            CupertinoTextField(
              inputFormatters: [UpperCaseTextFormatter()],
              controller: textEditingController,
            )
          ],
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            textStyle: const TextStyle(color: Colors.blue),
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            ///
            textStyle: const TextStyle(color: Colors.blue),
            isDestructiveAction: true,
            onPressed: () {
              ref
                  .watch(licensePlateProvider.notifier)
                  .add(textEditingController.text)
                  .then((value) {
                ref.watch(selectedLicenseProvider.notifier).state =
                    value.licensePlate;
                context.pop();
                return ref.refresh(licensePlateProvider);
              });
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _showCupertinoPicker(BuildContext context, WidgetRef ref) {
    List<String> periods = PeriodParkingList().generateParkingPeriods();
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: CupertinoPicker(
            onSelectedItemChanged: (value) => ref
                .watch(parkingPeriodProvider.notifier)
                .state = periods[value],
            useMagnifier: true,
            itemExtent: 42.0,
            children: List<Widget>.generate(periods.length, (int index) {
              return Center(
                child: Text(periods[index] == '30'
                    ? '${periods[index]} min'
                    : '${periods[index]} h'),
              );
            }),
          ),
        ),
      ),
    );
  }
}
