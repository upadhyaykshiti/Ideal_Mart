

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'registration_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  void completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => RegistrationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index) => setState(() => isLastPage = index == 2),
        children: [
          buildPage(
            image: "assets/onboarding1.png",
            title: "Welcome to Ideal Mart",
            desc: "Track your grocery needs easily and efficiently.",
          ),
          buildPage(
            image: "assets/onboarding2.png",
            title: "Add Items Quickly",
            desc: "Choose from templates or create custom shopping items.",
          ),
          buildPage(
            image: "assets/onboarding3.png",
            title: "Smart Reminders",
            desc: "Get notified when it's time to restock your essentials.",
          ),
        ],
      ),
      bottomSheet: isLastPage
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(60)),
              onPressed: completeOnboarding,
              child: Text("Get Started"),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: completeOnboarding,
                    child: Text("Skip"),
                  ),
                  Center(
                    child: SmoothPageIndicator(
                      controller: _controller,
                      count: 3,
                      effect: WormEffect(),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _controller.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                    child: Text("Next"),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildPage({required String image, required String title, required String desc}) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 250),
          SizedBox(height: 40),
          Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text(desc, textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
