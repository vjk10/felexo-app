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
        listener: AdListener(
            onAdClosed: (Ad ad) => print('AD CLOSED!'),
            onAdFailedToLoad: (Ad ad, LoadAdError error) {
              ad.dispose();
            },
            onAdOpened: (Ad ad) => print('AD OPENED!'),
            onAdLoaded: (Ad ad) => print('AD LOADED!')),
        request: AdRequest());
    return bannerAd;
  }

  static InterstitialAd _interstitialAd;

  static InterstitialAd _createInterstitialAd() {
    return InterstitialAd(
        adUnitId: interstitialAdUnitId,
        listener: AdListener(
            onAdClosed: (Ad ad) =>
                {print('AD CLOSED!'), _interstitialAd.dispose()},
            onApplicationExit: (Ad ad) => {_interstitialAd.dispose()},
            onAdFailedToLoad: (Ad ad, LoadAdError error) {
              ad.dispose();
            },
            onAdOpened: (Ad ad) => print('AD OPENED!'),
            onAdLoaded: (Ad ad) =>
                {print('AD LOADED!'), _interstitialAd.show()}),
        request: AdRequest());
  }

  static void showInterstitialAd() {
    _interstitialAd?.dispose();
    _interstitialAd = null;

    if (_interstitialAd == null) _interstitialAd = _createInterstitialAd();
    _interstitialAd.load();
  }
}
