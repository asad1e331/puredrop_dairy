import 'package:flutter/material.dart';

import '../../domain/entities/delivery.dart';

class DeliveryStatusBadge extends StatelessWidget {
  final DeliveryStatus status;

  const DeliveryStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final isDelivered = status == DeliveryStatus.delivered;

    final color = isDelivered
        ? const Color(0xFF15803D)
        : const Color(0xFFB45309);

    final backgroundColor = isDelivered
        ? const Color(0xFFDCFCE7)
        : const Color(0xFFFEF3C7);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isDelivered ? 'Delivered' : 'Pending',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
