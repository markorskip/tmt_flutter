import 'package:flutter_test/flutter_test.dart';
import 'package:tmt_flutter/util/formatter.dart';

void main() {

  test('Test dollar formatter', () {
    double dbl = 8000.00;
    String result = Formatter.dollarsFormatter(dbl);
    expect(result, "\$8,000");
  });

}