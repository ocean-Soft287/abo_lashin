import 'package:abolashin/core/auth/session_manager.dart';
import 'package:abolashin/core/servise_locator/services_locator.dart';
import 'package:abolashin/core/services/app_update/app_update_policy.dart';
import 'package:abolashin/core/services/app_update/app_update_service.dart';

enum StartupDestination { forceUpdate, home, login }

class StartupDecision {
  final StartupDestination destination;
  final AppUpdateCheck update;

  const StartupDecision(this.destination, this.update);
}

/// Decides where the app goes after the splash.
abstract final class SplashStartup {
  SplashStartup._();

  // One update check per app process, even if the splash is shown again.
  static Future<AppUpdateCheck>? _update;

  static Future<StartupDecision> decide() async {
    // AppUpdateService.check never throws; failures resolve to "no update".
    final update = await (_update ??= AppUpdateService.check());
    if (update.type == AppUpdateType.mandatory) {
      return StartupDecision(StartupDestination.forceUpdate, update);
    }
    AppUpdateService.setPendingOptional(update);
    final destination =
        getIt<SessionManager>().hasSession
            ? StartupDestination.home
            : StartupDestination.login;
    return StartupDecision(destination, update);
  }
}
