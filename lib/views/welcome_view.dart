import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/base/util/app_colors.dart';
import '../core/base/util/icon_utility.dart';
import '../core/base/util/img_utility.dart';
import '../core/base/util/text_utility.dart';
import 'get_started_view.dart';
import '../core/base/util/const_texts.dart';
import '../core/base/util/size_config.dart';

const List<Map<String, String>> slideData = [
  {
    "header": ConstTexts.slideOneHeader,
    "description": ConstTexts.slideOneDesc,
  },
  {
    "header": ConstTexts.slideTwoHeader,
    "description": ConstTexts.slideTwoDesc,
  },
  {
    "header": ConstTexts.slideThreeHeader,
    "description": ConstTexts.slideThreeDesc,
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
    Get.to(() => const GetStartedView())?.then((_) {
      if (mounted) {
        _pageController.jumpToPage(slideData.length - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

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
                  return const Center(child: CircularProgressIndicator());
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
              fontSize: 16.0,
              color: AppColors.dark.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

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
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
          24, 0, 24, MediaQuery.of(context).padding.bottom),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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

          Row(
            children: List.generate(pageCount, (index) {
              return _PageIndicator(isActive: index == currentPage);
            }),
          ),

          IconButton(
            onPressed: onRightTap,
            icon: Icon(
              isLastPage ? Icons.check : AppIcons.arrowRight,
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
      width: isActive ? 24 : 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppColors.lighter : AppColors.light,
      ),
    );
  }
}