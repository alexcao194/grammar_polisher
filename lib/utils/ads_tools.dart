import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsTools {
  const AdsTools._();

  static void requestNewInterstitial() {
    final adUnitId = Platform.isAndroid
        ? const String.fromEnvironment('ANDROID_INTERSTITIAL_AD_UNIT_ID')
        : const String.fromEnvironment('IOS_INTERSTITIAL_AD_UNIT_ID');
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (ad) {},
              onAdImpression: (ad) {},
              onAdFailedToShowFullScreenContent: (ad, err) {
                ad.dispose();
              },
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
              },
              onAdClicked: (ad) {});
          debugPrint('InterstitialAd loaded: $ad - unit id: $adUnitId');
          ad.show();
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error - unit id: $adUnitId');
        },
      ),
    );
  }
}
