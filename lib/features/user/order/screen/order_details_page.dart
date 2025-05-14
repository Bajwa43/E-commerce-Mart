import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vendoora_mart/features/user/home/domain/model/order/order_conform_model.dart';
import 'package:vendoora_mart/helper/firebase_helper/firebase_helper.dart';
import 'package:vendoora_mart/utiles/constants/colors.dart';

class UserOrderDetailsPage extends StatefulWidget {
  final OrderConformModel orderConformModel;

  const UserOrderDetailsPage({
    Key? key,
    required this.orderConformModel,
  }) : super(key: key);

  @override
  _UserOrderDetailsPageState createState() => _UserOrderDetailsPageState();
}

class _UserOrderDetailsPageState extends State<UserOrderDetailsPage> {
  late bool isConfirmed;

  @override
  void initState() {
    super.initState();
    // initialize local state from the model
    isConfirmed = widget.orderConformModel.orderSatus;
  }

  @override
  Widget build(BuildContext context) {
    final vendorOrders = widget.orderConformModel.orderItemVendor;
    final orderDate = DateFormat.yMMMEd()
        .add_jm()
        .format(widget.orderConformModel.orderDate.toDate());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
        backgroundColor: Colors.deepPurple.shade400,
        elevation: 0,
      ),
      body: vendorOrders.isEmpty
          ? const Center(
              child: Text(
                'No order details found.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildOrderSummary(orderDate),
                const SizedBox(height: 20),
                ...vendorOrders.map(_buildVendorSection).toList(),
              ],
            ),
    );
  }

  Widget _buildOrderSummary(String orderDate) {
    return Card(
      color: Colors.deepPurple.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Info',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            _infoRow(
                Icons.receipt, 'Order ID', widget.orderConformModel.orderID),
            _infoRow(Icons.calendar_today, 'Order Date', orderDate),
            _infoRow(Icons.payment, 'Payment',
                widget.orderConformModel.paymentMethod),
            _infoRow(
              Icons.attach_money,
              'Total',
              NumberFormat.currency(symbol: '₹')
                  .format(widget.orderConformModel.totalAmount),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(
                Icons.check_circle_outline,
                color: isConfirmed ? Colors.white : Colors.white,
              ),
              label: Text(
                isConfirmed ? 'Order Received' : 'Mark Order as Received',
                style: TextStyle(
                  color: isConfirmed ? Colors.white : Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isConfirmed ? Colors.white : Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: isConfirmed ? null : _confirmOrder,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVendorSection(VendorOrderSepModel vendor) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fetch and display the vendor name
            FutureBuilder<DocumentSnapshot>(
              future: HelperFirebase.orderConformInstance
                  .doc(vendor.venderID)
                  .get(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Text('Vendor: Loading...');
                }
                if (snap.hasError || !snap.hasData || !snap.data!.exists) {
                  return const Text('Vendor: Unknown');
                }
                final data = snap.data!.data() as Map<String, dynamic>;
                final name = data['name'] as String? ?? 'Unknown';
                return Text(
                  'Vendor: $name',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: TColors.white,
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            ...?vendor.productList.map((item) {
              final imageUrl = item.imageUrl ?? '';
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image, size: 40),
                        ),
                      )
                    : const Icon(Icons.broken_image, size: 40),
                title: Text(item.productName),
                subtitle: Text('Size: ${item.size} • Qty: ${item.quantity}'),
              );
            }).toList(),
            const Divider(height: 24, thickness: 1),
            Row(
              children: [
                const Icon(Icons.info_outline, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  'Order Status: ${isConfirmed ? 'Confirmed' : 'Pending'}',
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.deepPurple),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmOrder() async {
    try {
      await HelperFirebase.orderConformInstance
          .doc(widget.orderConformModel.orderID)
          .update({'orderSatus': true});

      setState(() {
        isConfirmed = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order marked as confirmed!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update order: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
