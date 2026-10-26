enum StoreUpdateStatus { available, notAvailable, unknown }

enum AppUpdateType { none, optional, mandatory }

class AppUpdateCheck {
  final AppUpdateType type;

  final String? latestVersionName;

  final String? releaseNotes;

  final int? availableVersionCode;

  const AppUpdateCheck({
    required this.type,
    this.latestVersionName,
    this.releaseNotes,
    this.availableVersionCode,
  });

  static const none = AppUpdateCheck(type: AppUpdateType.none);
}

abstract class AppUpdatePolicy {
  static const Duration snooze = Duration(days: 3);

  static AppUpdateType decide({
    required int installedBuild,
    required int minSupportedBuild,
    required StoreUpdateStatus store,
  }) {
    final belowMinimum =
        minSupportedBuild > 0 &&
        installedBuild > 0 &&
        installedBuild < minSupportedBuild;

    if (belowMinimum && store != StoreUpdateStatus.notAvailable) {
      return AppUpdateType.mandatory;
    }
    if (store == StoreUpdateStatus.available) return AppUpdateType.optional;
    return AppUpdateType.none;
  }

  static bool shouldShowOptional({
    required int? availableVersionCode,
    required int? dismissedVersionCode,
    required DateTime? dismissedAt,
    required DateTime now,
  }) {
    if (dismissedAt == null || dismissedVersionCode == null) return true;
    if (availableVersionCode != null &&
        availableVersionCode != dismissedVersionCode) {
      return true;
    }
    return now.difference(dismissedAt) >= snooze;
  }

  static String? cleanText(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }
}
