import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:atividade_02/main.dart';

void main() {
  testWidgets('Teste de cálculo de IMC', (WidgetTester tester) async {
    // contrucao do app
    await tester.pumpWidget(ImcApp());

    // encontra botao e campos.
    final pesoField = find.widgetWithText(TextFormField, 'Peso (kg)');
    final alturaField = find.widgetWithText(TextFormField, 'Altura (m)');
    final calcularButton = find.widgetWithText(ElevatedButton, 'Calcular');

    // insere valores validos.
    await tester.enterText(pesoField, '70');
    await tester.enterText(alturaField, '1.75');
    await tester.tap(calcularButton);

    // aguarda o resultado.
    await tester.pump();

    // verifica se o resutlado esta correto.
    expect(find.text('Peso normal'), findsOneWidget);
    expect(find.text('Parabéns! Continue assim!'), findsOneWidget);
  });
}
