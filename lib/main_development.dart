// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:perseus_front_mobile/app/app.dart';
import 'package:perseus_front_mobile/app_router.dart';
import 'package:perseus_front_mobile/bootstrap.dart';

void main() {
  bootstrap(() => App(appRouter: AppRouter()));
}
