import 'package:careerquest_flutter/app/app.dart';
import 'package:careerquest_flutter/bootstrap.dart';
import 'package:careerquest_flutter/core/flavor/flavor.dart';

Future<void> main() async {
  await bootstrap(() => const App(), AppFlavor.development);
}
