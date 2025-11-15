import 'package:flutter/material.dart';
import '../core/base/util/app_colors.dart';
import '../core/base/util/icon_utility.dart';
import '../core/base/util/img_utility.dart';
import '../core/base/util/text_utility.dart';
import '../core/base/util/const_texts.dart';
import 'get_started_view.dart';

const List<Map<String, String>> slideData = [
  {
    "header": ConstTexts.slideOneHeader,
    "description": ConstTexts.slideOneDesc
  },
  {
    "header": ConstTexts.slideTwoHeader,
    "description": ConstTexts.slideTwoDesc
  },
  {
    "header": ConstTexts.slideThreeHeader,
    "description": ConstTexts.slideThreeDesc
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

  void _goToGetStarted() {
    if (ModalRoute.of(context)?.isCurrent != true) return;

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const GetStartedView()),
    ).then((_) {
      if (mounted) {
        _pageController.jumpToPage(slideData.length - 1);
        setState(() {
          _currentPage = slideData.length - 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Image.asset(
            ImageUtility.welcomeImg,
            fit: BoxFit.cover,
            width: double.infinity,
          ),

          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: slideData.length + 1,
              onPageChanged: (index) {
                if (index == slideData.length) {
                  _goToGetStarted();
                } else {
                  setState(() {
                    _currentPage = index;
                  });
                }
              },
              itemBuilder: (context, index) {
                if (index == slideData.length) {
                  return Container(color: AppColors.white);
                }
                final slide = slideData[index];
                return _SlideContent(
                  header: slide['header']!,
                  description: slide['description']!,
                );
              },
            ),
          ),

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
                _goToGetStarted();
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
              fontSize: 16.0, // 16px
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
    final bool isLastPage = currentPage == pageCount - 1;

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
          AnimatedOpacity(
            opacity: isFirstPage ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: IconButton(
              onPressed: isFirstPage ? null : onLeftTap,
              icon: const Icon(
                AppIcons.arrowLeft,
                color: AppColors.light,
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
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: Icon(
                isLastPage ? Icons.check_rounded : AppIcons.arrowRight,
                key: ValueKey<bool>(isLastPage),
                color: AppColors.light,
              ),
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
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 10,
      width: isActive ? 24.0 : 10.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isActive ? AppColors.lighter : AppColors.light,
      ),
    );
  }
}