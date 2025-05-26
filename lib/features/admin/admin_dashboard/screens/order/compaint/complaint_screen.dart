import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vendoora_mart/helper/firebase_helper/firebase_helper.dart';

enum ComplaintStatus {
  open,
  inProgress,
  resolved;

  static ComplaintStatus fromString(String value) {
    return values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => ComplaintStatus.open,
    );
  }

  String get displayName {
    switch (this) {
      case ComplaintStatus.open:
        return 'Open';
      case ComplaintStatus.inProgress:
        return 'In Progress';
      case ComplaintStatus.resolved:
        return 'Resolved';
    }
  }

  Color get color {
    switch (this) {
      case ComplaintStatus.open:
        return const Color(0xFFFFA726);
      case ComplaintStatus.inProgress:
        return const Color(0xFF28C2A0);
      case ComplaintStatus.resolved:
        return const Color(0xFF66BB6A);
    }
  }

  IconData get icon {
    switch (this) {
      case ComplaintStatus.open:
        return Icons.warning_amber_rounded;
      case ComplaintStatus.inProgress:
        return Icons.build_circle_rounded;
      case ComplaintStatus.resolved:
        return Icons.verified_rounded;
    }
  }
}

class _SectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;

  _SectionHeaderDelegate({required this.title});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          color: const Color(0xFF28C2A0),
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  @override
  double get maxExtent => 56;
  @override
  double get minExtent => 56;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class AdminComplaintDetailScreen extends StatefulWidget {
  final String complaintId;
  final ComplaintStatus initialStatus;

  const AdminComplaintDetailScreen({
    Key? key,
    required this.complaintId,
    required this.initialStatus,
  }) : super(key: key);

  @override
  State<AdminComplaintDetailScreen> createState() =>
      _AdminComplaintDetailScreenState();
}

class _AdminComplaintDetailScreenState
    extends State<AdminComplaintDetailScreen> {
  late ComplaintStatus _selectedStatus;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final _primaryColor = const Color(0xFF28C2A0);

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.initialStatus;
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaint Details'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: _primaryColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8.r,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 15.w),
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.white, width: 1.5.w),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 120.w),
              child: _buildStatusDropdown(),
            ),
          ),
          IconButton(
            icon: Icon(Icons.save_rounded, color: Colors.white, size: 22.sp),
            onPressed: _updateComplaintStatus,
            tooltip: 'Save Status Changes',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 200.h,
                  collapsedHeight: 100.h,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _buildStatusHeader(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: _buildComplaintDetails(),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate:
                      _SectionHeaderDelegate(title: 'Conversation History'),
                ),
                _buildMessagesList(),
                SliverPadding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                16.w, 8.h, 16.w, MediaQuery.of(context).padding.bottom + 8.h),
            child: _buildMessageInput(),
          ),
        ],
      ),
      floatingActionButton: SafeArea(
        child: FloatingActionButton.small(
          onPressed: _scrollToBottom,
          backgroundColor: _primaryColor,
          child: Icon(
            Icons.arrow_downward_rounded,
            size: 20.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_primaryColor, _primaryColor.withOpacity(0.9)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('complaints')
            .doc(widget.complaintId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return _buildShimmerHeader();

          final rawData = snapshot.data!.data();
          if (rawData == null) {
            return Center(
              child: Text('Complaint data not found',
                  style: TextStyle(fontSize: 14.sp)),
            );
          }

          final data = rawData as Map<String, dynamic>;
          final status = ComplaintStatus.fromString(data['status']);

          return Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Case #${widget.complaintId.substring(0, 6).toUpperCase()}',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13.sp,
                    letterSpacing: 1.2.w,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  data['title'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8.w,
                  ),
                ),
                SizedBox(height: 14.h),
                _buildStatusIndicator(status),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildComplaintDetails() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: StreamBuilder<DocumentSnapshot>(
        stream: HelperFirebase.compaintsInstance
            .doc(widget.complaintId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return _buildShimmerDetails();

          final rawData = snapshot.data!.data();
          if (rawData == null) {
            return Center(
              child: Text('Complaint data not found',
                  style: TextStyle(fontSize: 14.sp)),
            );
          }

          final data = rawData as Map<String, dynamic>;

          return Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(16.r),
            shadowColor: _primaryColor.withOpacity(0.2),
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailItem(
                    icon: Icons.description_rounded,
                    title: 'Description',
                    value: data['description'],
                  ),
                  Divider(height: 40.h),
                  _buildDetailItem(
                    icon: Icons.category_rounded,
                    title: 'Category',
                    value: data['category'] ?? 'General',
                  ),
                  _buildDetailItem(
                    icon: Icons.person_rounded,
                    title: 'Submitted By',
                    value: data['createdBy'],
                    isUser: true,
                  ),
                  _buildDetailItem(
                    icon: Icons.calendar_month_rounded,
                    title: 'Created Date',
                    value: DateFormat('MMM dd, yyyy - hh:mm a')
                        .format((data['createdAt'] as Timestamp).toDate()),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
    bool isUser = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22.sp, color: _primaryColor),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6.h),
                isUser
                    ? FutureBuilder<String>(
                        future: _getUserName(value),
                        builder: (context, snapshot) {
                          return Text(
                            snapshot.data ?? 'Loading user...',
                            style: TextStyle(
                              color: _primaryColor,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      )
                    : Text(
                        value,
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 15.sp,
                          height: 1.4,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(ComplaintStatus status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: status.color, width: 1.5.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 18.sp, color: status.color),
          SizedBox(width: 8.w),
          Text(
            status.displayName,
            style: TextStyle(
              color: status.color,
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
              letterSpacing: 0.8.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('complaints')
          .doc(widget.complaintId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(color: _primaryColor),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final message = snapshot.data!.docs[index];
              return _buildMessageBubble(message);
            },
            childCount: snapshot.data!.docs.length,
          ),
        );
      },
    );
  }

  Widget _buildMessageBubble(DocumentSnapshot message) {
    final isAdmin = message['senderId'] == 'admin_id';
    final timestamp = message['timestamp'] as Timestamp?;
    final timeString = timestamp != null
        ? DateFormat('hh:mm a').format(timestamp.toDate())
        : '--:--';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment:
            isAdmin ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isAdmin ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: 280.w),
                  decoration: BoxDecoration(
                    color: isAdmin
                        ? _primaryColor.withOpacity(0.1)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                      bottomLeft: isAdmin ? Radius.circular(20.r) : Radius.zero,
                      bottomRight:
                          !isAdmin ? Radius.circular(20.r) : Radius.zero,
                    ),
                    border: Border.all(
                      color: isAdmin ? _primaryColor : Colors.grey[300]!,
                      width: 1.5.w,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8.r,
                        offset: Offset(0, 3.h),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message['text'],
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 15.sp,
                                height: 1.4,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 14.sp,
                                  color: Colors.grey[500],
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  timeString,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (isAdmin)
                        Positioned(
                          top: -8.h,
                          right: -8.w,
                          child: Container(
                            padding: EdgeInsets.all(5.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _primaryColor,
                            ),
                            child: Icon(
                              Icons.verified_rounded,
                              size: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Text(
                    isAdmin ? 'Admin Response' : 'User Message',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: _primaryColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.1),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.add_rounded, color: _primaryColor, size: 22.sp),
            onPressed: _attachFile,
            tooltip: 'Attach File',
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your response...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 16.h),
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 15.sp,
                ),
              ),
              maxLines: 3,
              minLines: 1,
              onChanged: (_) => setState(() {}),
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 15.sp,
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child: _messageController.text.isEmpty
                ? IconButton(
                    icon: Icon(Icons.mic_rounded,
                        color: _primaryColor, size: 22.sp),
                    onPressed: _startVoiceInput,
                    tooltip: 'Voice Input',
                  )
                : Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: FloatingActionButton.small(
                      onPressed: _sendAdminMessage,
                      backgroundColor: _primaryColor,
                      child: Icon(Icons.send_rounded,
                          color: Colors.white, size: 18.sp),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<String> _getUserName(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      return userDoc['name'] ?? 'Unknown User';
    } catch (e) {
      return 'User Not Found';
    }
  }

  Widget _buildShimmerHeader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100.w,
              height: 14.h,
              color: Colors.white,
            ),
            SizedBox(height: 16.h),
            Container(
              width: double.infinity,
              height: 28.h,
              color: Colors.white,
            ),
            SizedBox(height: 16.h),
            Container(
              width: 120.w,
              height: 32.h,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerDetails() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: EdgeInsets.all(20.w),
            height: 300.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ),
      ),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _buildStatusDropdown() {
    return DropdownButton<ComplaintStatus>(
      value: _selectedStatus,
      items: ComplaintStatus.values
          .map((status) => DropdownMenuItem(
                value: status,
                child: Row(
                  children: [
                    Icon(status.icon, color: status.color, size: 20.sp),
                    SizedBox(width: 8.w),
                    Text(
                      status.displayName,
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ],
                ),
              ))
          .toList(),
      onChanged: (status) => setState(() => _selectedStatus = status!),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      icon: Icon(Icons.arrow_drop_down_rounded, size: 24.sp),
    );
  }

  void _updateComplaintStatus() async {
    try {
      await FirebaseFirestore.instance
          .collection('complaints')
          .doc(widget.complaintId)
          .update({
        'status': _selectedStatus.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Status updated successfully'),
          backgroundColor: Colors.green[700],
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _sendAdminMessage() async {
    if (_messageController.text.isEmpty) return;

    try {
      await FirebaseFirestore.instance
          .collection('complaints')
          .doc(widget.complaintId)
          .collection('messages')
          .add({
        'text': _messageController.text,
        'senderId': 'admin_id',
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
      _scrollToBottom();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send: ${e.toString()}'),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _attachFile() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('File attachment feature coming soon!'),
      duration: Duration(seconds: 2),
    ));
  }

  void _startVoiceInput() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Voice input feature coming soon!'),
      duration: Duration(seconds: 2),
    ));
  }
}
