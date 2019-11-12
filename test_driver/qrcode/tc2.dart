// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('tao qrcode', () {

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    tap(SerializableFinder f) async{
      return driver.tap(f);
    }

    wait(SerializableFinder f) async{
      return driver.waitFor(f);
    }

    test('tc2', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      await tap(find.byTooltip('Open navigation menu'));
      await tap(find.byValueKey('taoqrcode'));
      await tap(find.byValueKey('inputqrcode'));
      await driver.enterText('');
      await tap(find.byValueKey('qrtao'));
      await wait(find.text('Trống'));
    });
  });
}