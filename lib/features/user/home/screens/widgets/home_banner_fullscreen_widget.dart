import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeBannerFullScreenWidget extends StatefulWidget {
  final List<String> imageUrls;

  const HomeBannerFullScreenWidget({super.key, required this.imageUrls});

  @override
  State<HomeBannerFullScreenWidget> createState() =>
      _HomeBannerFullScreenWidgetState();
}

class _HomeBannerFullScreenWidgetState
    extends State<HomeBannerFullScreenWidget> {
  int _currentIndex = 0;

  // Professional & gentle color scheme
  final Color primaryColor = const Color(0xFF3B3F72); // Muted Indigo
  final Color secondaryColor = const Color(0xFF6B7280); // Gray-500 (soft gray)
  final Color overlayGradientStart = Colors.black.withOpacity(0.55);
  final Color overlayGradientEnd = Colors.transparent;
  final Color glassBackground = Colors.white.withOpacity(0.12);
  final Color glassBorder = Colors.white.withOpacity(0.22);
  final Color textColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutBack,
          margin: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.22),
                blurRadius: 25,
                spreadRadius: 5,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: CarouselSlider.builder(
            itemCount: widget.imageUrls.length,
            options: CarouselOptions(
              height: 180.h,
              enlargeCenterPage: true,
              viewportFraction: 0.85,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              onPageChanged: (index, reason) {
                setState(() => _currentIndex = index);
              },
              scrollPhysics: const BouncingScrollPhysics(),
            ),
            itemBuilder: (context, index, realIndex) {
              final isActive = index == _currentIndex;
              final url = widget.imageUrls[index];
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 1.0, end: isActive ? 1.05 : 0.95),
                duration: const Duration(milliseconds: 350),
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        url,
                        fit: BoxFit.cover,
                      ),
                      // Gradient overlay
                      AnimatedOpacity(
                        opacity: isActive ? 0.42 : 0.25,
                        duration: const Duration(milliseconds: 400),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                overlayGradientStart,
                                overlayGradientEnd,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Glass blur with floating text
                      Positioned(
                        bottom: 18.h,
                        left: 18.w,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 18.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                color: glassBackground,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: glassBorder),
                              ),
                              child: Text(
                                "Exclusive Deal",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      blurRadius: 3,
                                      offset: Offset(0, 1),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Indicators with scale & color animations
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.imageUrls.asMap().entries.map((entry) {
            final isActive = _currentIndex == entry.key;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              margin: EdgeInsets.symmetric(horizontal: 6.w),
              height: isActive ? 12.h : 8.h,
              width: isActive ? 28.w : 12.w,
              decoration: BoxDecoration(
                color: isActive ? primaryColor : secondaryColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.45),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        )
                      ]
                    : [],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
