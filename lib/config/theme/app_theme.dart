import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

@immutable
class AppTheme {
  //private constructor
  const AppTheme._();

  static final light = FlexThemeData.light(
    scheme: FlexScheme.bigStone,
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurfacesVariantDialog,
    blendLevel: 40,
    appBarStyle: FlexAppBarStyle.scaffoldBackground,
    appBarOpacity: 0.95,
    appBarElevation: 0,
    background: Colors.lightBlue[100],
    onBackground: Colors.white,
    transparentStatusBar: true,
    tabBarStyle: FlexTabBarStyle.forBackground,
    tooltipsMatchBackground: true,
    swapColors: true,
    lightIsWhite: true,
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    fontFamily: GoogleFonts.poppins().fontFamily,
    subThemesData: const FlexSubThemesData(
      useTextTheme: true,
      fabUseShape: true,
      interactionEffects: true,
      bottomNavigationBarElevation: 0,
      bottomNavigationBarOpacity: 1,
      navigationBarOpacity: 1,
      navigationBarMutedUnselectedIcon: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorUnfocusedHasBorder: true,
      blendOnColors: true,
      blendTextTheme: true,
      popupMenuOpacity: 0.95,
    ),
  );
}
