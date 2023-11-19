import 'package:flutter/material.dart';

BoxDecoration gradientBoxDecoration() {
  return const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.white,
        Colors.lightBlueAccent,
        Colors.teal,
        Colors.black,
      ],
    ),
  );
}

class Sizes {
  static const p2 = 2.0;
  static const p4 = 4.0;
  static const p5 = 5.0;
  static const p6 = 6.0;
  static const p8 = 8.0;
  static const p10 = 10.0;
  static const p12 = 12.0;
  static const p14 = 14.0;
  static const p16 = 16.0;
  static const p18 = 18.0;
  static const p20 = 20.0;
  static const p22 = 22.0;
  static const p24 = 24.0;
  static const p28 = 28.0;
  static const p30 = 30.0;
  static const p32 = 32.0;
  static const p36 = 36.0;
  static const p40 = 40.0;
  static const p44 = 44.0;
  static const p48 = 48.0;
  static const p52 = 52.0;
  static const p56 = 56.0;
  static const p60 = 60.0;
  static const p64 = 64.0;
  static const p100 = 100.0;
  static const p120 = 120.0;
  static const p150 = 150.0;
  static const p250 = 250.0;
}

const gapW4 = SizedBox(width: Sizes.p4);
const gapW8 = SizedBox(width: Sizes.p8);
const gapW12 = SizedBox(width: Sizes.p12);
const gapW16 = SizedBox(width: Sizes.p16);
const gapW18 = SizedBox(width: Sizes.p18);
const gapW20 = SizedBox(width: Sizes.p20);
const gapW24 = SizedBox(width: Sizes.p24);
const gapW32 = SizedBox(width: Sizes.p32);
const gapW48 = SizedBox(width: Sizes.p48);
const gapW64 = SizedBox(width: Sizes.p64);

const gapH4 = SizedBox(height: Sizes.p4);
const gapH6 = SizedBox(height: Sizes.p6);
const gapH8 = SizedBox(height: Sizes.p8);
const gapH12 = SizedBox(height: Sizes.p12);
const gapH16 = SizedBox(height: Sizes.p16);
const gapH20 = SizedBox(height: Sizes.p20);
const gapH24 = SizedBox(height: Sizes.p24);
const gapH32 = SizedBox(height: Sizes.p32);
const gapH48 = SizedBox(height: Sizes.p48);
const gapH64 = SizedBox(height: Sizes.p64);
