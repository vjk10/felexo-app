import 'dart:io';

import 'package:felexo/Data/data.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdServices {
  static String get bannerAdUnitId =>
      Platform.isAndroid ? bannerAdId : bannerAdId;

  static String get interstitialAdUnitId =>
      Platform.isAndroid ? bannerAdId : bannerAdId;

  static intialize() {
    if (MobileAds.instance == null) {
      MobileAds.instance.initialize();
    }
  }

  static BannerAd createBannerAd() {
    BannerAd bannerAd = new BannerAd(
        size: AdSize.banner,
        adUnitId: bannerAdUnitId,
        listener: BannerAdListener(
            onAdClosed: (Ad ad) => print('AD CLOSED!'),
            onAdFailedToLoad: (Ad ad, LoadAdError error) {
              ad.dispose();
            },
            onAdOpened: (Ad ad) => print('AD OPENED!'),
            onAdLoaded: (Ad ad) => print('BANNER AD LOADED!')),
        request: AdRequest());
    return bannerAd;
  }
}
