import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Counter App', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite.
    final searchCityTextFieldFinder = find.byValueKey('searchCityTextField');
    final searchButtonFinder = find.byValueKey('searchButton');
    final cityForecastCard = find.byValueKey('cityForecastCard');

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

    test('text insertion updates textfield with correct value', () async {
      // Focus in the TextField
      await driver.tap(searchCityTextFieldFinder);
      // Type in the focused TextField
      await driver.enterText('brasília', timeout: Duration(seconds: 1));

      // Wait until the UI be updated
      await driver.waitFor(find.text('brasília'));
    });

    test('fills the card with the result from the server', () async {
      // Click on the button to the app perform the request
      await driver.tap(searchButtonFinder);

      // Define the Finders that will be populated with the api response
      final cityName = find.byValueKey('cityName');
      final temperature = find.byValueKey('temperature');
      final windSpeed = find.byValueKey('windSpeed');

      // Wait until the response come and pupulate the card
      await driver.waitFor(cityForecastCard);

      // Verify if the Text widgets were populated with the proper format
      expect(await driver.getText(cityName), 'Brasilia');
      expect(await driver.getText(temperature), matches(r"[\d]+\.[\d]+ ºC"));
      expect(await driver.getText(windSpeed), matches(r"[\d]+\.[\d]+ m/s"));
    });
  });
}
