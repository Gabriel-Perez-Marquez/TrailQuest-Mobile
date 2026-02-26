import 'package:flutter/material.dart';

class RouteStatsRow extends StatelessWidget {
  final double distanceKm;
  final int elevation;
  final String estimatedTime;
  final String routeType;

  const RouteStatsRow({
    super.key,
    required this.distanceKm,
    required this.elevation,
    this.estimatedTime = '',
    this.routeType = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatItem(
                value: '${distanceKm.toStringAsFixed(1)} km',
                label: 'TRAIL LENGTH',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _StatItem(
                value: '$elevation m',
                label: 'POSITIVE UNLEVELING',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _StatItem(
                value: estimatedTime.isNotEmpty ? estimatedTime : '—',
                label: 'ESTIMATED TIME',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: routeType.isNotEmpty
                  ? _StatItem(
                      value: routeType,
                      label: 'ROUTE TYPE',
                      icon: Icons.loop,
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData? icon;

  const _StatItem({
    required this.value,
    required this.label,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: const Color(0xFF1B512D), size: 22),
              const SizedBox(width: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1B512D),
                ),
              ),
            ],
          )
        else
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1B512D),
            ),
          ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF5C7A5C),
            letterSpacing: 0.8,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
} 

