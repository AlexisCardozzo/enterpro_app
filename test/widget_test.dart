// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:enterpro/main.dart';
import 'package:enterpro/providers/habit_provider.dart';
import 'package:enterpro/providers/gamification_provider.dart';
import 'package:enterpro/screens/habit_list_screen.dart';
import 'package:enterpro/services/database_helper.dart';
import 'package:mockito/annotations.dart';

// Generar el mock para DatabaseHelper
@GenerateMocks([DatabaseHelper])
import 'widget_test.mocks.dart';


void main() {
  group('App Integration Tests', () {
    late MockDatabaseHelper mockDatabaseHelper;

    setUp(() {
      mockDatabaseHelper = MockDatabaseHelper();
      // Configurar el mock para que getHabits devuelva una lista vacía por defecto
      when(mockDatabaseHelper.getHabits()).thenAnswer((_) async => []);
      // Asegurarse de que DatabaseHelper.instance devuelva nuestro mock
      // Esto requiere un cambio en DatabaseHelper para permitir la inyección de dependencias o un setter para la instancia.
      // Por ahora, asumiremos que podemos mockear la instancia directamente si es un singleton accesible.

    });

    testWidgets('App starts and shows HabitListScreen', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => HabitProvider(dbHelper: mockDatabaseHelper)),
            ChangeNotifierProvider(create: (context) => GamificationProvider()),
          ],
          child: const MyApp(),
        ),
      );
      await tester.pumpAndSettle(); // Esperar a que se resuelvan las animaciones y futuros
      expect(find.byType(HabitListScreen), findsOneWidget);
    });
  });
}
