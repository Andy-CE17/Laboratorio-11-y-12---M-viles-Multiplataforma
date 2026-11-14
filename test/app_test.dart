import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:laboratorio_11_cupertino/main.dart';

void main() {
  testWidgets('ingresa y muestra la navegación Cupertino', (tester) async {
    await tester.pumpWidget(const ProductApp());
    expect(find.text('Sistema de Productos'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(CupertinoTextField, 'Contraseña'),
      '123456',
    );
    await tester.tap(find.text('Iniciar sesión'));
    await tester.pumpAndSettle();

    expect(find.byType(CupertinoTabScaffold), findsOneWidget);
    expect(find.text('Productos registrados'), findsOneWidget);
  });
}
