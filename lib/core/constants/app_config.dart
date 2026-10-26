abstract class AppConfig {
  static const String androidPackageName = 'com.abolashine.theOne.abolashin';

  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=$androidPackageName';

  static const String playStoreMarketUrl =
      'market://details?id=$androidPackageName';

  static const String supportPhone = '201289064242';

  static const String supportWhatsApp = supportPhone;

  static const String? supportEmail = null;

  static const String? termsOfUseUrl = null;

  static const String developerCompanyName = 'The One System';

  static const String developerWebsite = 'http://theonesystemco.com/';
}

abstract class AppUpdateConfigKeys {
  static const String minSupportedVersionCode = 'min_supported_version_code';

  static const String latestVersionName = 'latest_version_name';

  static const String releaseNotesAr = 'update_release_notes_ar';
  static const String releaseNotesEn = 'update_release_notes_en';
}
