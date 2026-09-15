/// Canonical peso formatting: `₱` + thousands comma + two decimals.
///
/// `₱6,399.00` everywhere customer-facing. Never `Php.`, never bare
/// `toStringAsFixed` without grouping (see grill rounds 1-3, 2026-09-15).
String formatPeso(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final digits = parts[0];
  final buf = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buf.write(',');
    buf.write(digits[i]);
  }
  return '₱${buf.toString()}.${parts[1]}';
}
