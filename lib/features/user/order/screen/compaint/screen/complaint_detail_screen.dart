// complain_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ComplainScreen extends StatelessWidget {
  final String complaintId;
  final String userId;

  const ComplainScreen({required this.complaintId, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.of(context).pop(), // Back button functionality
        ),
        title: Text('Complaint Details'),
        backgroundColor: Color(0xFF24786D),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('complaints')
                  .doc(complaintId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());

                final complaint = snapshot.data!;
                return SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildComplaintHeader(complaint),
                      SizedBox(height: 20),
                      _buildStatusIndicator(complaint['status']),
                      SizedBox(height: 20),
                      _buildMessagesList(),
                    ],
                  ),
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildComplaintHeader(DocumentSnapshot complaint) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              complaint['title'],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              complaint['description'],
              style: TextStyle(color: Colors.grey[600]),
            ),
            Divider(height: 30),
            _buildDetailRow('Category', complaint['category']),
            _buildDetailRow(
                'Created',
                DateFormat('dd MMM yyyy - hh:mm a')
                    .format((complaint['createdAt'] as Timestamp).toDate())),
            _buildDetailRow(
                'Last Updated',
                DateFormat('dd MMM yyyy - hh:mm a')
                    .format((complaint['updatedAt'] as Timestamp).toDate())),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
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
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildMessagesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('complaints')
          .doc(complaintId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final message = snapshot.data!.docs[index];
            return _buildMessageBubble(message);
          },
        );
      },
    );
  }

  Widget _buildMessageBubble(DocumentSnapshot message) {
    bool isMe = message['senderId'] == userId;
    final timestamp = message['timestamp'];

    DateTime? messageTime;

    if (timestamp is Timestamp) {
      messageTime = timestamp.toDate();
    } else if (timestamp is DateTime) {
      messageTime = timestamp;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              constraints: BoxConstraints(maxWidth: 300),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMe ? Color(0xFF24786D) : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message['text'],
                    style: TextStyle(color: isMe ? Colors.white : Colors.black),
                  ),
                  if (messageTime != null)
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        DateFormat('hh:mm a').format(messageTime),
                        style: TextStyle(
                            color: isMe ? Colors.white70 : Colors.grey[600],
                            fontSize: 12),
                      ),
                    )
                  else
                    Text(
                      '--:--',
                      style: TextStyle(
                          color: isMe ? Colors.white70 : Colors.grey[600],
                          fontSize: 12),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    final TextEditingController _controller = TextEditingController();

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey[200]!, blurRadius: 8)],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
          SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Color(0xFF24786D),
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: () async {
                if (_controller.text.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('complaints')
                      .doc(complaintId)
                      .collection('messages')
                      .add({
                    'text': _controller.text,
                    'senderId': userId,
                    'timestamp': FieldValue.serverTimestamp(),
                  });
                  _controller.clear();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
