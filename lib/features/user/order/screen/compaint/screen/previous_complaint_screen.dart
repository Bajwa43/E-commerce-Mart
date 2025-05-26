// import 'package:final_project/Student/complaign_Screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:vendoora_mart/features/user/order/screen/compaint/screen/complaint_detail_screen.dart';

class PreviousComplaintsScreen extends StatelessWidget {
  final String userId;

  const PreviousComplaintsScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    print('ID IS >> $userId');
    return Scaffold(
      appBar: AppBar(
        title: Text('Previous Complaints'),
        backgroundColor: Color(0xFF24786D),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('complaints')
            .where('createdId', isEqualTo: userId)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text(snapshot.error.toString()));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No complaints found'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final complaint = snapshot.data!.docs[index];
              return _buildComplaintCard(complaint, context);
            },
          );
        },
      ),
    );
  }

  Widget _buildComplaintCard(DocumentSnapshot complaint, BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(complaint['title'],
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${complaint['category']}'),
            Text('Status: ${complaint['status']}'),
            Text(
              DateFormat('dd MMM yyyy - hh:mm a')
                  .format((complaint['createdAt'] as Timestamp).toDate()),
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        trailing: _buildStatusIndicator(complaint['status']),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ComplainScreen(
              complaintId: complaint.id,
              userId: userId,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String status) {
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'open':
        statusColor = Colors.orange;
        break;
      case 'in-progress':
        statusColor = Colors.blue;
        break;
      case 'resolved':
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: statusColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
