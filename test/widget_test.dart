// ============================================================================
//  Widget tests for the Travel Explorer app.
//  They verify the main features of the assignment: loading state, search,
//  category filters, favourites and navigation to the details screen.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:travel_explorer_app/main.dart';

void main() {
  // Pumps the app and skips the 2 second "fake API" delay.
  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const TravelExplorerApp());
    await tester.pump(); // shows the CircularProgressIndicator
    await tester.pump(const Duration(seconds: 2)); // the "server" answers
    await tester.pump(); // rebuilds the screen with the destinations
  }

  testWidgets('shows the loading state and then the destinations', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TravelExplorerApp());
    await tester.pump();

    // The simulated API is still "loading" -> progress indicator visible.
    expect(find.byType(CircularProgressIndicator), findsWidgets);

    await tester.pump(const Duration(seconds: 2));
    await tester.pump();

    // The data arrived -> the list of destinations is displayed.
    expect(find.text('Travel Explorer'), findsOneWidget);
    expect(find.text('Machu Picchu'), findsOneWidget);
    expect(find.text('12 destinations'), findsOneWidget);
  });

  testWidgets('live search filters the destinations', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    // Search by name.
    await tester.enterText(find.byType(TextField), 'Machu');
    await tester.pump();
    expect(find.text('Machu Picchu'), findsOneWidget);
    expect(find.text('1 destination'), findsOneWidget);

    // Search by location.
    await tester.enterText(find.byType(TextField), 'Japan');
    await tester.pump();
    expect(find.text('Kyoto Old Town'), findsOneWidget);
    expect(find.text('Machu Picchu'), findsNothing);
  });

  testWidgets('category chips filter the destinations', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.widgetWithText(FilterChip, 'Mountains'));
    await tester.pump();

    // Only the 2 mountain destinations are kept.
    expect(find.text('2 destinations'), findsOneWidget);
    expect(find.text('Mount Everest Base Camp'), findsOneWidget);
    expect(find.text('Machu Picchu'), findsNothing);
  });

  testWidgets('shows the empty state when nothing matches', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    await tester.enterText(find.byType(TextField), 'zzzzz');
    await tester.pump();

    expect(find.text('No destinations found'), findsOneWidget);
    expect(find.text('0 destinations'), findsOneWidget);
  });

  testWidgets('the heart icon adds and removes a favourite', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    expect(find.text('♥ 0'), findsOneWidget);

    // Add Machu Picchu to the favourites.
    await tester.tap(
      find.descendant(
        of: find.ancestor(
          of: find.text('Machu Picchu'),
          matching: find.byType(Card),
        ),
        matching: find.byIcon(Icons.favorite_border),
      ),
    );
    await tester.pump();
    expect(find.text('♥ 1'), findsOneWidget);

    // Tap again to remove it.
    await tester.tap(find.byIcon(Icons.favorite).first);
    await tester.pump();
    expect(find.text('♥ 0'), findsOneWidget);
  });

  testWidgets('opens the details screen and goes back', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    // Open the details screen.
    await tester.tap(find.text('Machu Picchu'));
    await tester.pumpAndSettle();

    expect(find.text('About this place'), findsOneWidget);
    expect(find.text('Highlights'), findsOneWidget);
    expect(find.text('Add to favourites'), findsOneWidget);

    // Back navigation with the AppBar back button.
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('Travel Explorer'), findsOneWidget);
    expect(find.text('12 destinations'), findsOneWidget);
  });

  // ---------------------------------------------------------------------------
  //  ERROR STATE
  // ---------------------------------------------------------------------------
  testWidgets('shows the error state and the retry button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TravelExplorerApp());
    await tester.pump();

    // Switch ON the simulated API error (the wifi button in the AppBar).
    await tester.tap(find.byTooltip('Simulate an API error'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();

    // The error state is displayed.
    expect(find.text('Something went wrong'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    expect(find.text('Machu Picchu'), findsNothing);

    // Turn the simulated error OFF and retry -> the data comes back.
    await tester.tap(find.byTooltip('Simulated error is ON - tap to fix'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();

    expect(find.text('12 destinations'), findsOneWidget);
  });

  // ---------------------------------------------------------------------------
  //  FORM VALIDATION
  // ---------------------------------------------------------------------------
  testWidgets('the trip planner form validates the empty fields', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    // Go to the details screen and then to the form screen.
    await tester.tap(find.text('Machu Picchu'));
    await tester.pumpAndSettle();

    // The "Plan your trip" button is at the bottom -> scroll to it first.
    await tester.ensureVisible(find.text('Plan your trip'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Plan your trip'));
    await tester.pumpAndSettle();

    expect(find.text('Plan your trip'), findsWidgets);

    // Submit the empty form -> the validation messages appear.
    // The submit button is at the bottom of the scroll view.
    await tester.scrollUntilVisible(
      find.text('Request this trip'),
      120,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Request this trip'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter your full name'), findsOneWidget);
    expect(find.text('Please enter your email address'), findsOneWidget);
    expect(
      find.text('Please enter how many people are travelling'),
      findsOneWidget,
    );
    expect(find.text('Please choose a travel date'), findsOneWidget);
  });

  testWidgets('the form rejects a bad email and a bad traveller count', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.text('Machu Picchu'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Plan your trip'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Plan your trip'));
    await tester.pumpAndSettle();

    // Fill the form with an invalid email and an invalid number.
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Full name'),
      'Ali',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email address'),
      'not-an-email',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Number of travellers'),
      '99',
    );
    // The submit button is at the bottom of the scroll view. The form is
    // taller than the test window, so we scroll it into view before tapping.
    await tester.scrollUntilVisible(
      find.text('Request this trip'),
      120,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Request this trip'));
    await tester.pumpAndSettle();

    expect(
      find.text('Please enter a valid email (e.g. name@gmail.com)'),
      findsOneWidget,
    );
    expect(
      find.text('The number of travellers must be between 1 and 20'),
      findsOneWidget,
    );
    // The name "Ali" is 3 characters, so it is accepted.
    expect(find.text('Name must be at least 3 characters long'), findsNothing);
  });
}
