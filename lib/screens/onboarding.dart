import 'package:flutter/material.dart';

import 'home_screen.dart';
import '../widgets/custom_button.dart';
import '../core/theme/theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  final List<Map<String, dynamic>> onboardingData = [
    {
      "icon": Icons.warning_rounded,
      "title": "Instant SOS Help",
      "description":
      "Trigger emergency help in seconds with one tap.",
    },
    {
      "icon": Icons.location_on,
      "title": "Live Location Sharing",
      "description":
      "Trusted contacts receive your live GPS location instantly.",
    },
    {
      "icon": Icons.mic,
      "title": "Voice, Face & Motion AI",
      "description":
      "Get help silently using voice, face and motion detection.",
    },
  ];

  void _nextPage() {
    if (currentIndex < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    }
  }

  Widget _dot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 10,
      width: isActive ? 24 : 10,
      decoration: BoxDecoration(
        color: isActive
            ? AppTheme.primaryRed
            : Colors.grey,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: onboardingData.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final item = onboardingData[index];

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundColor: AppTheme.primaryRed,
                          child: Icon(
                            item["icon"],
                            size: 70,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          item["title"],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          item["description"],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardingData.length,
                      (index) => _dot(index == currentIndex),
                ),
              ),

              const SizedBox(height: 30),

              CustomButton(
                text: currentIndex == onboardingData.length - 1
                    ? "GET STARTED"
                    : "NEXT",
                icon: Icons.arrow_forward,
                onPressed: _nextPage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}