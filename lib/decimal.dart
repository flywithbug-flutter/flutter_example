import 'package:decimal/decimal.dart';

import 'package:decimal/intl.dart';
import 'package:intl/intl.dart';

// ignore: non_constant_identifier_names
void decimal_test() {
  // const d = Decimal.parse;

  // var _volume24h = d('0');

  // var x = Decimal.parse('12315.656790');
  // print(x.toStringAsFixed(2));

  // print(x.formatKMB()); // 12K
  // print(x.formatKMB(scale: 1)); // 12.3K
  // print(x.formatKMB(scale: 2)); // 12.31K
  // print(x.formatKMB(scale: -1)); // 10K

  // print(x.formatKMB(ceil: true)); // 13K
  // print(x.formatKMB(scale: 1, ceil: true)); // 12.4K
  // print(x.formatKMB(scale: 2, ceil: true)); // 12.32K
  // print(x.formatKMB(scale: -1, ceil: true)); // 20K
}

extension DecimalExt on Decimal {
  String format() => NumberFormat.decimalPattern('en-US').format(DecimalIntl(this));

  /// 数字大额展示单位转换
  /// K 1000  千
  /// M 1000000  百万
  /// B 1000000000  十亿
  /// var x = Decimal.parse('12312.4567');
  /// x.formatKMB(ceil:true); // 13K
  /// x.formatKMB(scale: 1,ceil:true); // 12.4K
  /// x.formatKMB(scale: 2,ceil:true); // 12.32K
  /// x.formatKMB(scale: -1,ceil:true); // 20K
  /// x.formatKMB(); // 12K
  /// x.formatKMB(scale: 1); // 12.3K
  /// x.formatKMB(scale: 2); // 12.31K
  /// x.formatKMB(scale: -1); // 10K
  String formatKMB({int scale = 0, bool ceil = false}) {
    final k = Decimal.fromInt(1000);
    final m = Decimal.fromInt(1000000);
    final b = Decimal.fromInt(1000000000);
    if (this >= b) {
      if (ceil) {
        return '${(this / b).toDecimal().ceil(scale: scale).format()}B';
      } else {
        return '${(this / b).toDecimal().floor(scale: scale).format()}B';
      }
    } else if (this >= m) {
      if (ceil) {
        return '${(this / m).toDecimal().ceil(scale: scale).format()}M';
      } else {
        return '${(this / m).toDecimal().floor(scale: scale).format()}M';
      }
    } else if (this >= k) {
      if (ceil) {
        return '${(this / k).toDecimal().ceil(scale: scale).format()}K';
      } else {
        return '${(this / k).toDecimal().floor(scale: scale).format()}K';
      }
    } else {
      if (ceil) {
        return this.ceil(scale: scale).format();
      } else {
        return floor(scale: scale).format();
      }
    }
  }
}

extension NumberFormatExt on String {
  String get currency => (Decimal.tryParse(this) ?? Decimal.zero).format();
}
