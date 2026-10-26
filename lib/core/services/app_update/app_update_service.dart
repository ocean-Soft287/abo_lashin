import 'dart:async';
import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:abolashin/core/constants/app_config.dart';
import 'package:abolashin/core/local/app_preferences.dart';
import 'package:abolashin/core/servise_locator/services_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:abolashin/core/services/app_update/app_update_policy.dart';

abstract class AppUpdateService {
  static const Duration _timeout = Duration(seconds: 6);
  static const String _dismissedCodeKey = 'update_dismissed_version_code';
  static const String _dismissedAtKey = 'update_dismissed_at';

  @visibleForTesting
  static Future<AppUpdateCheck> Function() checker = _check;

  static AppUpdateCheck? _pendingOptional;
  static bool _optionalShownThisSession = false;

  static Future<AppUpdateCheck> check() async {
    try {
      return await checker().timeout(_timeout);
    } catch (_) {
      return AppUpdateCheck.none;
    }
  }

  static Future<AppUpdateCheck> _check() async {
    final installedBuild = await _installedBuild();
    final results = await Future.wait([_storeInfo(), _remoteConfig()]);
    final store = results[0] as _StoreInfo;
    final remote = results[1] as FirebaseRemoteConfig?;

    final minSupported =
        remote?.getInt(AppUpdateConfigKeys.minSupportedVersionCode) ?? 0;
    final type = AppUpdatePolicy.decide(
      installedBuild: installedBuild,
      minSupportedBuild: minSupported,
      store: store.status,
    );
    if (type == AppUpdateType.none) return AppUpdateCheck.none;

    final notesKey =
        getIt<AppPreferences>().languageCode == 'en'
            ? AppUpdateConfigKeys.releaseNotesEn
            : AppUpdateConfigKeys.releaseNotesAr;
    return AppUpdateCheck(
      type: type,
      latestVersionName: AppUpdatePolicy.cleanText(
        remote?.getString(AppUpdateConfigKeys.latestVersionName),
      ),
      releaseNotes: AppUpdatePolicy.cleanText(remote?.getString(notesKey)),
      availableVersionCode: store.versionCode,
    );
  }

  static Future<int> _installedBuild() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return int.tryParse(info.buildNumber) ?? 0;
    } catch (_) {
      return 0;
    }
  }

  static Future<_StoreInfo> _storeInfo() async {
    if (kIsWeb || !Platform.isAndroid) return const _StoreInfo.unknown();
    try {
      final info = await InAppUpdate.checkForUpdate();
      switch (info.updateAvailability) {
        case UpdateAvailability.updateAvailable:
        case UpdateAvailability.developerTriggeredUpdateInProgress:
          return _StoreInfo(
            StoreUpdateStatus.available,
            info.availableVersionCode,
          );
        case UpdateAvailability.updateNotAvailable:
          return const _StoreInfo(StoreUpdateStatus.notAvailable, null);
        case UpdateAvailability.unknown:
          return const _StoreInfo.unknown();
      }
    } catch (_) {
      return const _StoreInfo.unknown();
    }
  }

  static Future<FirebaseRemoteConfig?> _remoteConfig() async {
    try {
      final config = FirebaseRemoteConfig.instance;
      await config.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 5),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );
      await config.setDefaults(const {
        AppUpdateConfigKeys.minSupportedVersionCode: 0,
        AppUpdateConfigKeys.latestVersionName: '',
        AppUpdateConfigKeys.releaseNotesAr: '',
        AppUpdateConfigKeys.releaseNotesEn: '',
      });
      try {
        await config.fetchAndActivate();
      } catch (_) {}
      return config;
    } catch (_) {
      return null;
    }
  }

  static void setPendingOptional(AppUpdateCheck result) {
    if (result.type == AppUpdateType.optional) _pendingOptional = result;
  }

  static AppUpdateCheck? takePendingOptional({DateTime? now}) {
    final pending = _pendingOptional;
    if (pending == null || _optionalShownThisSession) return null;
    _pendingOptional = null;

    final dismissedMs = _preferences.get(_dismissedAtKey);
    final show = AppUpdatePolicy.shouldShowOptional(
      availableVersionCode: pending.availableVersionCode,
      dismissedVersionCode: _intOrNull(_preferences.get(_dismissedCodeKey)),
      dismissedAt:
          dismissedMs is int
              ? DateTime.fromMillisecondsSinceEpoch(dismissedMs)
              : null,
      now: now ?? DateTime.now(),
    );
    if (!show) return null;
    _optionalShownThisSession = true;
    return pending;
  }

  static Future<void> snooze(AppUpdateCheck result) async {
    await _preferences.setInt(
      _dismissedAtKey,
      DateTime.now().millisecondsSinceEpoch,
    );
    await _preferences.setInt(
      _dismissedCodeKey,
      result.availableVersionCode ?? 0,
    );
  }

  static SharedPreferences get _preferences => getIt<SharedPreferences>();

  static int? _intOrNull(Object? value) => value is int ? value : null;

  @visibleForTesting
  static void resetSession() {
    _pendingOptional = null;
    _optionalShownThisSession = false;
  }
}

class _StoreInfo {
  final StoreUpdateStatus status;
  final int? versionCode;

  const _StoreInfo(this.status, this.versionCode);

  const _StoreInfo.unknown()
    : status = StoreUpdateStatus.unknown,
      versionCode = null;
}
