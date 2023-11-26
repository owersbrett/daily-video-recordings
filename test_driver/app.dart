// // Import flutter_driver and the screenshots package
// import 'package:flutter_driver/flutter_driver.dart';
// import 'package:flutter_launcher_icons/config/config.dart';
// import 'package:flutter_test/flutter_test.dart';


// void main() {
//   group('App Screenshots', () async {
//     final driver = await FlutterDriver.connect();
//     final config = Config();

//     test('take screenshots', () async {
//       await driver.waitFor(ByTooltipMessage());
//       // Add logic to navigate through your app

//       // Take a screenshot
//       await screenshot(driver, config, 'home_screen');
//     });

//     // Add more tests for other screens

//     tearDownAll(() async {
//       if (driver != null) {
//         driver.close();
//       }
//     });
//   });
// }
