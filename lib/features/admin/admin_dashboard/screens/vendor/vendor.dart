import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// import 'package:vendoora_mart/features/admin/admin_dashboard/screens/vendor/screen/vednor_detail_page.dart';
import 'package:vendoora_mart/features/admin/admin_dashboard/screens/vendor/screen/vendor_detail_page.dart';
import 'package:vendoora_mart/features/admin/controller/admin_controller.dart';
import 'package:vendoora_mart/helper/helper_functions.dart';

class AdminVendorsPage extends StatelessWidget {
  final tabs = ['Accepted', 'Pending', 'Rejected'];

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
                "🏪 Vendors Overview",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),

              // PageView/Chip Selector
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: tabs.map((tab) {
                      final isSelected =
                          controller.selectedVendorTab.value == tab;
                      return GestureDetector(
                        onTap: () => controller.selectedVendorTab.value = tab,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.5),
                            ),
                          ),
                          child: Text(
                            tab,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )),
              SizedBox(height: 20),

              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search vendors by name or ID...',
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

              // Filtered Vendor List
              Obx(() {
                final vendors = controller.filteredVendors;

                return Expanded(
                  child: vendors.isEmpty
                      ? Center(child: Text("No vendors in this category."))
                      : ListView.builder(
                          itemCount: vendors.length,
                          itemBuilder: (context, index) {
                            final vendor = vendors[index];
                            return Card(
                              elevation: 2,
                              margin: EdgeInsets.only(bottom: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.green,
                                        backgroundImage: vendor.logoUrl !=
                                                    null &&
                                                vendor.logoUrl!.isNotEmpty
                                            ? NetworkImage(vendor.logoUrl!)
                                            : AssetImage(
                                                    'assets/images/default_avatar.png')
                                                as ImageProvider,
                                      ),
                                      title: Text(vendor.business ?? "Vendor"),
                                      subtitle: Text(
                                          "Email: ${vendor.email}\nCity: ${vendor.city ?? 'N/A'}"),
                                      trailing: Icon(Icons.arrow_forward_ios,
                                          size: 16),
                                      onTap: () {
                                        // Navigate to vendor profile/details
                                        // AdminNavController controller =
                                        //     Get.find<AdminNavController>();
                                        // controller
                                        //     .bindOrdersStream(vendor.userId!);
                                        HelperFunctions.navigateToScreen(
                                            context: context,
                                            screen: VendorDetailPage(
                                                vendor: vendor));
                                      },
                                    ),
                                    if (vendor.approved == false)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              controller.updateVendorStatus(
                                                  true, vendor.userId!);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                            ),
                                            child: Text("Approve"),
                                          ),
                                          SizedBox(width: 12.w),
                                          TextButton(
                                            onPressed: () {
                                              controller.updateVendorStatus(
                                                  null, vendor.userId!);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            child: Text("Reject"),
                                          ),
                                        ],
                                      ),
                                    if (vendor.approved == null)
                                      // Spacer(),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton(
                                          onPressed: () {
                                            controller.updateVendorStatus(
                                                true, vendor.userId!);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                          ),
                                          child: Text("Approve"),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
