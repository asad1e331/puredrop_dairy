import 'package:flutter/material.dart';

import '../../domain/entities/delivery.dart';
import 'delivery_status_badge.dart';

class DeliveryCard extends StatelessWidget {
  final Delivery delivery;

  const DeliveryCard({super.key, required this.delivery});

  @override
  Widget build(BuildContext context) {
    final date = delivery.date;

    final formattedDate = '${date.day}/${date.month}/${date.year}';

    final quantity = '${delivery.quantity.toStringAsFixed(1)} L';

    final screenWidth = MediaQuery.sizeOf(context).width;
    final isCompact = screenWidth < 360;

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE8EDF3)),
      ),
      child: Padding(
        padding: EdgeInsets.all(isCompact ? 12 : 16),
        child: Row(
          children: [
            Container(
              width: isCompact ? 42 : 48,
              height: isCompact ? 42 : 48,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.local_drink_outlined,
                color: Color(0xFF1677D2),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: isCompact ? 13 : 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF172B4D),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'Milk: $quantity',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 6),

            DeliveryStatusBadge(status: delivery.status),
          ],
        ),
      ),
    );
  }
}
