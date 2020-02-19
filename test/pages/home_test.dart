import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_testing/pages/home.dart';
import 'package:flutter_testing/services/weather_service.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../fixtures/weather_fixture.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  testWidgets('insert and remove forecast of searched city', (
    WidgetTester tester,
  ) async {
    // http client mock
    MockClient mockClient = MockClient();
    when(mockClient.get(anything)).thenAnswer(
      (_) async => http.Response(weatherJsonResponse, 200),
    );

    // service mock
    WeatherService service =
        WeatherService(apiKey: 'anyapikey', client: mockClient);

    // build the app and trigger the frame render
    Widget widget = MaterialApp(home: Home(service: service));
    await tester.pumpWidget(widget);

    // verify that there is no card in the widget
    expect(find.byType(Card), findsNothing);

    // perform search
    await tester.enterText(find.byType(TextField), 'brasília');
    await tester.tap(find.byType(FlatButton));

    // await the widget be reloaded with the new state
    await tester.pumpAndSettle();

    // expect to find a card with the searched city name
    expect(find.byType(Card), findsOneWidget);

    // drag the card to delete it
    await tester.drag(find.byType(Dismissible), Offset(500.0, 0.0));

    // await the widget be reloaded with the new state
    await tester.pumpAndSettle();

    // expect to do not find deleted card
    expect(find.byType(Card), findsNothing);
  });
}
