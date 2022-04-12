import 'package:flutter/cupertino.dart';
import 'package:perseus_front_mobile/pages/login/view/login_page.dart';
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
      default:
        return null;
    }
  }
}
