import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdConsentService {
  AdConsentService._();

  static final AdConsentService instance = AdConsentService._();

  bool _consentGatheringComplete = false;

  bool get consentGatheringComplete => _consentGatheringComplete;

  Future<bool> requestConsentIfNeeded({bool debugGeography = false}) async {
    final completer = Completer<bool>();

    final params = ConsentRequestParameters(
      consentDebugSettings: debugGeography
          ? ConsentDebugSettings(
              debugGeography: DebugGeography.debugGeographyEea,
            )
          : null,
      tagForUnderAgeOfConsent: false,
    );

    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        try {
          if (await ConsentInformation.instance.isConsentFormAvailable()) {
            await _loadAndShowConsentFormIfRequired();
          }
        } catch (e) {
          debugPrint('AdConsentService: consent form error. $e');
        } finally {
          _consentGatheringComplete = true;
          if (!completer.isCompleted) completer.complete(true);
        }
      },
      (FormError error) {
        debugPrint(
          'AdConsentService: requestConsentInfoUpdate failed: ${error.message}',
        );
        _consentGatheringComplete = true;
        if (!completer.isCompleted) completer.complete(true);
      },
    );

    return completer.future;
  }

  Future<void> _loadAndShowConsentFormIfRequired() async {
    final completer = Completer<void>();

    ConsentForm.loadConsentForm(
      (ConsentForm consentForm) async {
        final status = await ConsentInformation.instance.getConsentStatus();
        if (status == ConsentStatus.required) {
          consentForm.show((FormError? showError) {
            completer.complete();
          });
        } else {
          completer.complete();
        }
      },
      (FormError error) {
        debugPrint(
          'AdConsentService: loadConsentForm failed: ${error.message}',
        );
        completer.complete();
      },
    );

    return completer.future;
  }

  Future<bool> canRequestAds() async {
    return ConsentInformation.instance.canRequestAds();
  }

  Future<void> showPrivacyOptionsForm() async {
    final completer = Completer<void>();
    ConsentForm.showPrivacyOptionsForm((FormError? formError) {
      completer.complete();
    });
    return completer.future;
  }
}
