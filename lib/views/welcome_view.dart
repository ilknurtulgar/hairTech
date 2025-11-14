import 'package:flutter/material.dart';
import '../core/base/util/app_colors.dart';
import '../core/base/util/icon_utility.dart';
import '../core/base/util/img_utility.dart';
import '../core/base/util/text_utility.dart';

const List<Map<String, String>> slideData = [
  {
    "header": "Soruları yanıtla, yatkınlığını ölçelim",
    "description": "Yılların getirdiği tecrübemizle hazırladığımız soruları cevapla, genetik açıdan saç kaybına yatkınlığın var mı öğren."
  },
  {
    "header": "Randevu al ve uzman kadromuzla görüş",
    "description": "Dilersen saçının fotoğraflarını yükle ve randevu oluştur, doktorlarımızla yüzyüze görüşme gerçekleştir."
  },
  {
    "header": "Tedavi sürecini\ntek yerden yönet",
    "description": "Tedavi sürecini, belirli periyodlarla fotoğraflar yükleyerek ve doktorundan dönüş alarak tek yerden yönet!"
  }
];

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          // 1. FIXED Top Image
          Image.asset(
            ImageUtility.welcomeImg,
            fit: BoxFit.cover,
            width: double.infinity,
          ),

          // 2. SLIDABLE Middle Section
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: slideData.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final slide = slideData[index];
                return _SlideContent(
                  header: slide['header']!,
                  description: slide['description']!,
                );
              },
            ),
          ),

          // 3. FIXED Bottom Navigation Bar
          _BottomNavBar(
            currentPage: _currentPage,
            pageCount: slideData.length,
            onLeftTap: () {
              if (_currentPage > 0) {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            },
            onRightTap: () {
              if (_currentPage < slideData.length - 1) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              } else {
                // On last page, go to Home or Login
                // print("Go to Login Screen");
              }
            },
          ),
        ],
      ),
    );
  }
}

class _SlideContent extends StatelessWidget {
  final String header;
  final String description;

  const _SlideContent({required this.header, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: TextUtility.headerStyle,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: TextUtility.getStyle(
              fontSize: 18.0,
              color: AppColors.dark,
            ),
          ),
        ],
      ),
    );
  }
}

// Helper Widget for the Bottom Navigation Bar (Fixed)
class _BottomNavBar extends StatelessWidget {
  final int currentPage;
  final int pageCount;
  final VoidCallback onLeftTap;
  final VoidCallback onRightTap;

  const _BottomNavBar({
    required this.currentPage,
    required this.pageCount,
    required this.onLeftTap,
    required this.onRightTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isFirstPage = currentPage == 0;

    return Container(
      height: 70 + MediaQuery.of(context).padding.bottom,
      decoration: const BoxDecoration(
        color: AppColors.darker,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
          24, 0, 24, MediaQuery.of(context).padding.bottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Arrow
          Opacity(
            opacity: isFirstPage ? 0.0 : 1.0,
            child: IconButton(
              onPressed: isFirstPage ? null : onLeftTap,
              icon: const Icon(
                AppIcons.arrowLeft,
                color: AppColors.lighter,
              ),
            ),
          ),

          // Page Indicator
          Row(
            children: List.generate(pageCount, (index) {
              return _PageIndicator(isActive: index == currentPage);
            }),
          ),

          // Right Arrow
          IconButton(
            onPressed: onRightTap,
            icon: const Icon(
              AppIcons.arrowRight,
              color: AppColors.lighter,
            ),
          ),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final bool isActive;
  const _PageIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppColors.lighter : AppColors.light,
      ),
    );
  }
}
