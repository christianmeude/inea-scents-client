import '../api/models/package.dart';

/// Tier helpers over a [Package]'s `pax_prices` map (`{pax: price}`).
///
/// One package renders as one card per tier ("50 Guests — ₱4,499").
/// Packages without a tier map fall back to legacy behavior (scalar
/// price, `paxOptions` list) so old/test payloads keep working.
class PackageTier {
  final int pax;
  final double price;

  const PackageTier(this.pax, this.price);

  String get title => '$pax Guests';

  String get priceLabel => '₱${price.toStringAsFixed(0)}';
}

extension PackageTiers on Package {
  /// Ordered tier entries. Empty when the package has no tier map —
  /// callers then fall back to `paxOptions`/scalar price.
  List<PackageTier> get tiers {
    final map = paxPrices;
    if (map == null || map.isEmpty) return const [];
    final entries = map.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return [for (final e in entries) PackageTier(e.key, e.value)];
  }

  bool get hasTiers => tiers.isNotEmpty;

  /// Price for a headcount, or the scalar base price as fallback.
  /// Bare packages (no price at all) fall back to the historic 4500.00
  /// display default so summary surfaces never render ₱0.00.
  double priceForPax(int? pax) {
    if (pax != null) {
      final map = paxPrices;
      if (map != null && map.containsKey(pax)) return map[pax]!;
    }
    return price ?? 4500.0;
  }

  /// "Starts at" line for package headers.
  String get startsAtLabel {
    final base = tiers.isEmpty
        ? (price ?? 0)
        : tiers.map((t) => t.price).reduce((a, b) => a < b ? a : b);
    return 'Starts at ₱${base.toStringAsFixed(0)}';
  }
}
