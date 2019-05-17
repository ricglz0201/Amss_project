import 'package:amss_project/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Custom card widget has attrs', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: CustomCard(
            label: 'hello',
            color: Colors.blue,
            icon: Icon(Icons.aspect_ratio)
          ),
        ),
      )
    );
    final Finder labelFinder = find.text('hello');
    final Finder colorFinder = find.byIcon(Icons.aspect_ratio);

    expect(labelFinder, findsOneWidget);
    expect(colorFinder, findsOneWidget);
  });
}
