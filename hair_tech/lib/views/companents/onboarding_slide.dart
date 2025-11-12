import 'package:flutter/material.dart';

// This is a reusable widget for each slide's content.
// This keeps your welcome_screen.dart file clean.
class OnboardingSlide extends StatelessWidget {
  // Güncellendi: Prop'lar değişti
  final String slideImage;
  final String title;
  final String text;

  const OnboardingSlide({
    super.key,
    required this.slideImage,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Güncellendi: Üstteki mavi kutu yerine 3:4 görsel
        AspectRatio(
          aspectRatio: 4.0 / 3.0,
          child: Image.asset(
            slideImage,
            fit: BoxFit.cover, // Görselin alanı doldurmasını sağlar
            width: double.infinity,
            gaplessPlayback: true, // Slayt geçişlerinde atlamayı önler
          ),
        ),
        // Bottom white part of the slide
        Expanded(
          child: Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(), // Pushes content to the middle
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                ),
                const SizedBox(height: 16),
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.black54,
                        height: 1.5, // Improves readability
                      ),
                ),
                const Spacer(flex: 2), // Takes up more space
              ],
            ),
          ),
        ),
      ],
    );
  }
}