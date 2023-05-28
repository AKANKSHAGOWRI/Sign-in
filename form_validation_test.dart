import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registration_app/main.dart';

void main() {
  testWidgets('Empty form submission shows error messages', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: RegistrationForm()));

    // Tap the Submit button
    await tester.tap(find.text('Submit'));
    await tester.pump();

    // Expect error messages for each form field
    expect(find.text('Please enter your first name'), findsOneWidget);
    expect(find.text('Please enter your last name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your phone number'), findsOneWidget);
  });

  testWidgets('Valid form submission shows success message', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: RegistrationForm()));

    // Fill in the form fields
    await tester.enterText(find.byKey(ValueKey('firstNameField')), 'John');
    await tester.enterText(find.byKey(ValueKey('lastNameField')), 'Doe');
    await tester.tap(find.byKey(ValueKey('dateOfBirthField')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(ValueKey('emailField')), 'john.doe@example.com');
    await tester.enterText(find.byKey(ValueKey('phoneNumberField')), '1234567890');

    // Tap the Submit button
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    // Expect success message
    expect(find.text('Form submitted successfully'), findsOneWidget);
  });
}
