import 'package:flutter/material.dart';
import 'size_config.dart'; // SizeConfig class’ını import et

class ResponsePadding {

  /// Genel sayfa padding (sayfalar ortalanmış)
  static EdgeInsets page() {
    return EdgeInsets.all(SizeConfig.responsiveWidth(16));
  }

  /// Reklam sayfası padding (top 50, left and rigth 16)
  static EdgeInsets adPage() {
  return EdgeInsets.only(
    top: SizeConfig.responsiveHeight(50),
    left: SizeConfig.responsiveWidth(32),
    right: SizeConfig.responsiveWidth(32),
  );
}

  /// Randevu listeleri arası boşluk (vertical)
  static EdgeInsets appointmentList() {
    return EdgeInsets.symmetric(vertical: SizeConfig.responsiveHeight(25));
  }

  /// TextField ve button arası padding (vertical)
  static EdgeInsets formElements() {
    return EdgeInsets.symmetric(vertical: SizeConfig.responsiveHeight(15));
  }

  /// Yatay kaydırmalı seçim containerları arası
  static EdgeInsets horizontalScrollItem() {
    return EdgeInsets.symmetric(horizontal: SizeConfig.responsiveWidth(10));
  }

  /// Randevu kaydırmalı containerlar (büyük 25, küçük 20)
  static double appointmentScrollLarge() => SizeConfig.responsiveWidth(25);
  static double appointmentScrollSmall() => SizeConfig.responsiveWidth(20);

  /// Genel containerlar arası boşluk
  static EdgeInsets generalContainer() {
    return EdgeInsets.all(SizeConfig.responsiveWidth(10));
  }

  /// Küçük resim kaydırmalı görseller arası
  static EdgeInsets smallImageScroll() {
    return EdgeInsets.all(SizeConfig.responsiveWidth(2));
  }

  /// Büyük resim kaydırmalı görseller arası
  static EdgeInsets largeImageScroll() {
    return EdgeInsets.all(SizeConfig.responsiveWidth(15));
  }

  /// Alt başlıklar padding
  static EdgeInsets subHeader() {
    return EdgeInsets.all(SizeConfig.responsiveWidth(2));
  }

  /// Genel başlıklar padding
  static EdgeInsets header() {
    return EdgeInsets.all(SizeConfig.responsiveWidth(10));
  }

  /// Hasta listeleri arası padding
  static EdgeInsets patientList() {
    return EdgeInsets.symmetric(vertical: SizeConfig.responsiveHeight(10));
  }

  /// Sayfa başlık padding
  static EdgeInsets pageTitle() {
    return EdgeInsets.all(SizeConfig.responsiveWidth(15));
  }
}
