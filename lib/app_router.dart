import 'package:flutter/cupertino.dart';
import 'package:perseus_front_mobile/model/exercise.dart';
import 'package:perseus_front_mobile/pages/exercise_details/view/exercise_detail_page.dart';
import 'package:perseus_front_mobile/pages/home/view/home_page.dart';
import 'package:perseus_front_mobile/pages/login/view/login_page.dart';
import 'package:perseus_front_mobile/pages/notification/view/notification_page.dart';
import 'package:perseus_front_mobile/pages/profile/view/profile_page.dart';
import 'package:perseus_front_mobile/pages/register/view/register_page.dart';

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
      case '/exercise':
        final arg = settings.arguments as Exercise?;

        if (arg != null) {
          return CupertinoPageRoute<dynamic>(
            builder: (_) => ExerciseDetailPage(exercise: arg),
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
