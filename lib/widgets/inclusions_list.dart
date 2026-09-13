import 'package:flutter/material.dart';
import 'card_surfaces.dart';

/// Shared inclusions list (P7 C): renders Inclusions + Free subsections
/// with wrap-don't-truncate behavior. Used by OrderSummaryPanel and
/// package detail surfaces so the dark toggle recolors through CardSurfaces.
class InclusionsList extends StatelessWidget {
  final List<String> inclusions;
  final List<String> freebies;

  const InclusionsList({
    super.key,
    required this.inclusions,
    required this.freebies,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = CardSurfaces.title(context);
    final bodyColor = CardSurfaces.body(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Inclusions',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: titleColor,
          ),
        ),
        const SizedBox(height: 6),
        if (inclusions.isEmpty)
          Text(
            'No inclusions listed',
            style: TextStyle(fontSize: 12, color: bodyColor),
          )
        else
          ...inclusions.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('•  ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: titleColor)),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                          fontSize: 12, color: titleColor, height: 1.35),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (freebies.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            'Free',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 6),
          ...freebies.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('•  ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: titleColor)),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                          fontSize: 12, color: titleColor, height: 1.35),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
