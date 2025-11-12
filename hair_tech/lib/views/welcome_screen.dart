import 'package:flutter/material.dart';
import 'package:hair_tech/views/login_screen.dart'; // <-- Update with your app name
import 'package:hair_tech/views/companents/onboarding_slide.dart'; // <-- Update with your app name

class WelcomeScreen extends StatefulWidget {
  // routeName is a common practice for defining route names as constants
  static const String routeName = '/';

  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // This is the data for your three slides
  // NOT: Slayt görselleri için 'assets/images/slide_1.png' vb. eklemelisiniz.
  final List<Map<String, String>> _slideData = [
    {
      "slideImage":
          "assets/images/onboarding_image.png", // Güncellendi: Tek bir görsel
      "title": "Soruları yanıtla, yatkınlığını ölçelim",
      "text":
          "Yılların getirdiği tecrübemizle hazırladığımız soruları cevapla, genetik açıdan saç kaybına yatkınlığını var mı öğren.",
    },
    {
      "slideImage":
          "assets/images/onboarding_image.png", // Güncellendi: Tek bir görsel
      "title": "Randevu al ve uzman kadromuzla görüş",
      "text":
          "Dilersen saçının fotoğraflarını yükle ve randevu oluştur, doktorlarımızla yüzyüze görüşme gerçekleştir.",
    },
    {
      "slideImage":
          "assets/images/onboarding_image.png", // Güncellendi: Tek bir görsel
      "title": "Tedavi sürecini tek yerden yönet",
      "text":
          "Tedavi sürecini, belirli periyodlarla fotoğraflar yükleyerek ve doktorundan dönüş alarak tek yerden yönet!",
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_currentPage == _slideData.length - 1) {
      // This is the last page, navigate to LoginScreen
      // We use pushReplacementNamed so the user can't go "back" to onboarding
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    } else {
      // Go to the next page
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  // Geri butonu için yeni fonksiyon
  void _onBackPressed() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // This is the dark blue color from your design
    const Color kDarkBlue = Color(0xFF0A2540);

    return Scaffold(
      backgroundColor: Colors.white, // Default background for the screen
      body: Column(
        children: [
          // PageView takes up all available space above the bottom bar
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _slideData.length,
              onPageChanged: (value) {
                setState(() {
                  _currentPage = value;
                });
              },
              itemBuilder: (context, index) => OnboardingSlide(
                // Güncellendi: Yeni prop'lar
                slideImage: _slideData[index]['slideImage']!,
                title: _slideData[index]['title']!,
                text: _slideData[index]['text']!,
              ),
            ),
          ),
          // This is the custom bottom navigation bar
          Container(
            height: 80, // Gives space for padding and content
            decoration: const BoxDecoration(
              color: kDarkBlue,
              borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
            ),
            child: Padding(
              // Güncellendi: Kenarlara yatay padding eklendi
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0)
                  .copyWith(bottom: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 1. Sol Geri Oku (Sadece 2. ve 3. sayfalarda)
                  // Güncellendi: SizedBox kaldırıldı
                  Visibility(
                    visible: _currentPage > 0,
                    maintainSize: true, // Alanı koru
                    maintainAnimation: true,
                    maintainState: true,
                    child: IconButton(
                      // Güncellendi: İkon ve padding
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: _onBackPressed,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(), // Sıkılaştırır
                    ),
                  ),

                  // 2. Ortalanmış Noktalar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slideData.length,
                      (index) => buildDot(index, kDarkBlue),
                    ),
                  ),

                  // 3. Sağ İleri Oku
                  // Güncellendi: Daire butonu kaldırıldı, IconButton eklendi
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                    onPressed: _onNextPressed,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(), // Sıkılaştırır
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget to build the animated page indicator dots
  Widget buildDot(int index, Color kDarkBlue) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8.0),
      height: 10,
      width: _currentPage == index ? 20 : 10,
      decoration: BoxDecoration(
        // Active dot is white, inactive is a lighter blue
        color: _currentPage == index ? Colors.white : const Color(0xFF1E4266),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}