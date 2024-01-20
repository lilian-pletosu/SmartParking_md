import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:searchfield/searchfield.dart';
import 'package:smart_parking_md/config/routes/routes.dart';
import 'package:smart_parking_md/data/models/models.dart';
import 'package:smart_parking_md/providers/providers.dart';

Widget reusableItem({
  required String title,
  required BuildContext context,
  required deviceSize,
  required colors,
}) {
  return Flexible(
    child: InkWell(
      onTap: () => context.pushNamed(addParkingRouteName),
      child: Container(
        width: deviceSize.width,
        height: deviceSize.height * 0.1,
        decoration: BoxDecoration(
          color: colors.onBackground,
          boxShadow: kElevationToShadow[1],
        ),
        child: Center(
            child: Text(
          title,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: colors.secondary),
        )),
      ),
    ),
  );
}

Widget reusableWhiteText(
    {required String text,
    color = Colors.white,
    fontsize = 17,
    FontWeight fontWeight = FontWeight.w500}) {
  return Text(
    text,
    style: TextStyle(color: color, fontSize: 17, fontWeight: fontWeight),
  );
}

Widget reusableContainerPaymentMethod(
    {required String text,
    color = Colors.white,
    bool selected = false,
    fontColor = Colors.white,
    FontWeight fontWeight = FontWeight.w600}) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
        color: color,
        border: selected ? Border.all(width: 1.5, color: Colors.white) : null,
        borderRadius: BorderRadius.circular(5),
        boxShadow: kElevationToShadow[1]),
    child: reusableWhiteText(
        text: text,
        color: selected ? Colors.white : fontColor,
        fontWeight: fontWeight),
  );
}

Widget containerEmitInput(
    {String? text,
    color = Colors.white,
    Widget? lead,
    Color? iconColor,
    bool textCenter = false,
    double? height,
    bool border = false,
    double? width,
    fontSize = 18.0,
    void Function()? iconFunction}) {
  return InkWell(
    onTap: iconFunction,
    child: Container(
      height: height,
      decoration: BoxDecoration(
          color: color,
          border: border ? Border.all() : null,
          borderRadius: BorderRadius.circular(5),
          boxShadow: kElevationToShadow[1]),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      width: width,
      child: text != null
          ? Align(
              alignment: textCenter ? Alignment.center : Alignment.centerLeft,
              child: lead != null
                  ? Row(
                      children: [
                        lead,
                        const Gap(5),
                        Text(
                          text,
                          style: TextStyle(
                              fontSize: fontSize, fontWeight: FontWeight.w600),
                        ),
                      ],
                    )
                  : Text(
                      text,
                      style: TextStyle(
                          fontSize: fontSize, fontWeight: FontWeight.w600),
                    ),
            )
          : lead,
    ),
  );
}

Widget emitRegistrationNumber(
    {required String text,
    color = Colors.white,
    double? width,
    fontSize = 18.0}) {
  return Container(
    decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
        boxShadow: kElevationToShadow[1]),
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
    width: width,
    child: Row(
      children: [
        Column(
          children: [
            Image.network(
              'https://flagpedia.net/data/flags/w580/md.webp',
              width: 25,
            ),
            reusableWhiteText(
                text: 'MD', color: Colors.black, fontWeight: FontWeight.w600)
          ],
        ),
        const Gap(8),
        Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "GMB",
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
            ),
            Text('152',
                style:
                    TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600))
          ],
        ))
      ],
    ),
  );
}

Widget reusableShadowContainer(
    {required Widget child,
    Color color = Colors.white,
    double? height,
    double? width}) {
  return Container(
    // padding: EdgeInsets.all(5),
    height: height,
    width: width,
    decoration: BoxDecoration(boxShadow: kElevationToShadow[1], color: color),
    child: child,
  );
}

Widget emitLicensePlate() {
  return Container(
    padding: const EdgeInsets.all(1),
    decoration: BoxDecoration(
        border: Border.all(), borderRadius: BorderRadius.circular(3)),
    child: Row(
      children: [
        Image.network(
          'https://flagpedia.net/data/flags/w580/md.webp',
          width: 12,
        ),
        const Text(
          'ABC123',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
        ),
      ],
    ),
  );
}

Widget headerPage(
    {required colors,
    required deviceSize,
    required position,
    required WidgetRef ref}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8),
    color: colors.secondary,
    width: deviceSize.width,
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          reusableWhiteText(
              text: 'Plătește parcare în', color: colors.background),
          const Gap(8),
          InkWell(
              onTap: () => print('change city'),
              child: containerEmitInput(
                  text: position.value.toString(), width: deviceSize.width)),
          const Gap(10),
          reusableWhiteText(text: 'Metoda de plată', color: colors.background),
          const Gap(8),
          SizedBox(
            height: 40, // Specificați o înălțime fixă pentru ListView
            child: ListView.builder(
              itemCount: 2,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: reusableContainerPaymentMethod(
                    text: 'SMS',
                    // selected: true,
                    color: colors.secondaryContainer,
                    fontColor: colors.onTertiary,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

Widget customSection({
  required colors,
  required width,
  Color? textColor,
  double? height,
  required String sectionTitle,
  required Widget child,
}) {
  return Container(
    width: width,
    height: height,
    color: colors,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          reusableWhiteText(
              text: sectionTitle,
              // color: colors.secondary,
              color: textColor ?? Colors.white,
              fontWeight: FontWeight.w600,
              fontsize: 17),
          const Gap(8),
          child,
        ],
      ),
    ),
  );
}
