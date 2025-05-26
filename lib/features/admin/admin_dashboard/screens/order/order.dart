// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vendoora_mart/features/admin/admin_dashboard/screens/order/compaint/complaint_screen.dart';
import 'package:vendoora_mart/features/admin/controller/admin_controller.dart';
import 'package:vendoora_mart/features/user/order/domain/model/complaint_model.dart';
import 'package:vendoora_mart/helper/firebase_helper/firebase_helper.dart';

class AdminCompaintsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminNavController>();
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                "🧾 Orders Complaints",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),

              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search orders by ID or customer name...',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Complaint List Placeholder
              Expanded(
                child: Container(
                  color: Colors.grey[50],
                  child: Column(
                    children: [
                      // Complaints List
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('complaints')
                              .orderBy('createdAt', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return _buildShimmerList();
                            }

                            if (snapshot.data!.docs.isEmpty) {
                              return Center(
                                child: Text(
                                  'No Complaints Found',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18,
                                  ),
                                ),
                              );
                            }

                            return ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                final complaint = snapshot.data!.docs[index];
                                final data =
                                    complaint.data() as Map<String, dynamic>;
                                final status =
                                    ComplaintStatus.fromString(data['status']);

                                return _ComplaintCard(
                                  complaint: complaint,
                                  status: status,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AdminComplaintDetailScreen(
                                        complaintId: complaint.id,
                                        initialStatus: status,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildShimmerList() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => Container(
        height: 150,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}

class _ComplaintCard extends StatelessWidget {
  final DocumentSnapshot complaint;
  final ComplaintStatus status;
  final VoidCallback onTap;

  const _ComplaintCard({
    required this.complaint,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final data = complaint.data() as Map<String, dynamic>;
    final createdAt = DateFormat('MMM dd, yyyy - hh:mm a')
        .format((data['createdAt'] as Timestamp).toDate());

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth * 0.95; // 95% of available width
        final isWideScreen = cardWidth > 400;

        return Container(
          width: cardWidth,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: _buildStatusIndicator(status),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Case #${complaint.id.substring(0, 6).toUpperCase()}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: isWideScreen ? 14 : 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Title
                    Text(
                      data['title'] ?? 'No Title',
                      style: TextStyle(
                        fontSize: isWideScreen ? 20 : 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[800],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      data['description'] ?? 'No Description',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: isWideScreen ? 15 : 14,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),

                    // Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // User Info
                        Expanded(
                          child: Row(
                            children: [
                              Icon(Icons.person_outline,
                                  size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  data['createdBy'] ?? 'Unknown User',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: isWideScreen ? 14 : 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Date
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.calendar_today,
                                  size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  createdAt,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: isWideScreen ? 14 : 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusIndicator(ComplaintStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: status.color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 16, color: status.color),
          const SizedBox(width: 6),
          Text(
            status.displayName,
            style: TextStyle(
              color: status.color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
