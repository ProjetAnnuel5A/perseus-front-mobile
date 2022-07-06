import 'package:perseus_front_mobile/app/app.dart';
import 'package:perseus_front_mobile/app_router.dart';
import 'package:perseus_front_mobile/bootstrap.dart';

void main() {
  bootstrap(() => App(appRouter: AppRouter()));
}
