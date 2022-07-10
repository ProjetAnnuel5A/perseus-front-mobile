import 'package:flutter/cupertino.dart';
import 'package:perseus_front_mobile/model/set.dart';
import 'package:perseus_front_mobile/pages/home/view/home_page.dart';
import 'package:perseus_front_mobile/pages/login/view/login_page.dart';
import 'package:perseus_front_mobile/pages/notification/view/notification_page.dart';
import 'package:perseus_front_mobile/pages/profile/view/profile_page.dart';
import 'package:perseus_front_mobile/pages/register/view/register_page.dart';
import 'package:perseus_front_mobile/pages/set_details/view/set_detail_page.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return CupertinoPageRoute<dynamic>(
          builder: (_) => const LoginPage(),
        );
      case '/login':
        return CupertinoPageRoute<dynamic>(
          builder: (_) => const LoginPage(),
        );
      case '/register':
        return CupertinoPageRoute<dynamic>(
          builder: (_) => const RegisterPage(),
        );
      case '/home':
        return CupertinoPageRoute<dynamic>(
          builder: (_) => const HomePage(),
        );
      case '/workout':
        return CupertinoPageRoute<dynamic>(
          builder: (_) => const HomePage(),
        );
      case '/set':
        final arg = settings.arguments as Map?;

        if (arg != null) {
          final set = arg['set'] as Set;
          final workoutDate = arg['workoutDate'] as DateTime;

          return CupertinoPageRoute<dynamic>(
            builder: (_) => SetDetailPage(set: set, workoutDate: workoutDate),
          );
        }
        break;
      case '/profile':
        return CupertinoPageRoute<dynamic>(
          builder: (_) => const ProfilePage(),
        );
      case '/notification':
        return CupertinoPageRoute<dynamic>(
          builder: (_) => const NotificationPage(),
        );
      default:
        return null;
    }
    return null;
  }
}
