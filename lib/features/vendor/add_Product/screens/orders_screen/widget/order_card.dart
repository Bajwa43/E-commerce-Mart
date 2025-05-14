import 'package:flutter/material.dart';

class VendorOrderCard extends StatelessWidget {
  final String customerName;
  final DateTime orderDate;
  final List<Map<String, dynamic>> items;

  const VendorOrderCard({
    super.key,
    required this.customerName,
    required this.orderDate,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    int total = items.fold(
        0, (sum, item) => sum + (item['quantity'] * item['price']) as int);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.lightBlue[100], // Sea blue shade
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Customer: $customerName",
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text("Date: ${orderDate.day}/${orderDate.month}/${orderDate.year}",
              style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item['name'] ?? '',
                      style: const TextStyle(fontSize: 15)),
                  Text("Qty: ${item['quantity'] ?? 0}"),
                  Text("₹${item['price'] ?? 0}",
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
            );
          }),
          const Divider(),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Total: ₹$total",
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            ),
          )
        ],
      ),
    );
  }
}
