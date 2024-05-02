import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../../helpers/testing_utils.dart';

void main() {
  group('Directionality Utils', () {
    testWidgets('onRTL context variant', (tester) async {
      await tester.pumpWidget(createDirectionality(TextDirection.rtl));
      var context = tester.element(find.byType(Container));

      expect(onRTL.build(context), true, reason: 'rtl');
      expect(onLTR.build(context), false, reason: 'ltr');
    });

    testWidgets('onLTR context variant', (tester) async {
      await tester.pumpWidget(createDirectionality(TextDirection.ltr));
      var context = tester.element(find.byType(Container));

      expect(onRTL.build(context), false, reason: 'rtl');
      expect(onLTR.build(context), true, reason: 'ltr');
    });

    test('OnDirectionality equality', () {
      final variantRTL1 = OnDirectionalityVariant(TextDirection.rtl);
      final variantRTL2 = OnDirectionalityVariant(TextDirection.rtl);
      final variantLTR = OnDirectionalityVariant(TextDirection.ltr);

      expect(variantRTL1, equals(variantRTL2));
      expect(variantRTL1, isNot(equals(variantLTR)));
    });
  });
}
