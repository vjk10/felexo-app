import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';

ThemeMode brightness = ThemeMode.system;

// String googleIcon = FlutterConfig.get('GOOGLE_ICON');
String bannerAdId = FlutterConfig.get('BANNER_AD_ID');
String interstitialAdId = FlutterConfig.get('INTERSTITIAL_AD_ID');
String apiKey = FlutterConfig.get('API_KEY_PEXELS');
String loadingAnimation = FlutterConfig.get('LOADING_ANIMATION');

List defaultSuggestions = [];
List autoComplete = [];
List searchHistory = [];

String loadingMessage = "LOADING IMAGES";
String loadMoreMessage = "LOAD MORE";
String loadingText = "LOADING...";
