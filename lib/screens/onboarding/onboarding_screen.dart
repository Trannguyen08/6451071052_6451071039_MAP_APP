import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Món ăn đa dạng',
      'description': 'Khám phá hàng trăm món ăn nhanh hấp dẫn từ các thương hiệu nổi tiếng.',
      'icon': '🍔',
    },
    {
      'title': 'Giao hàng nhanh chóng',
      'description': 'Đội ngũ giao hàng luôn sẵn sàng để mang món ngon đến tận cửa nhà bạn.',
      'icon': '🛵',
    },
    {
      'title': 'Ưu đãi cực khủng',
      'description': 'Săn deal hời mỗi ngày và tích điểm đổi quà cùng FoodHero.',
      'icon': '🎁',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.orange.shade50,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextButton(
                    onPressed: () => Get.offAllNamed(AppRoutes.login),
                    child: Text(
                      'Bỏ qua', 
                      style: TextStyle(
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.w600,
                      )
                    ),
                  ),
                ),
              ),
              
              // Content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (value) {
                    setState(() {
                      _currentPage = value;
                    });
                  },
                  itemCount: _onboardingData.length,
                  itemBuilder: (context, index) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon with background decoration
                      Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.2),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Text(
                          _onboardingData[index]['icon']!,
                          style: const TextStyle(fontSize: 100),
                        ),
                      ),
                      const SizedBox(height: 60),
                      Text(
                        _onboardingData[index]['title']!,
                        style: TextStyle(
                          fontSize: 28, 
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade900,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          _onboardingData[index]['description']!,
                          style: TextStyle(
                            fontSize: 16, 
                            color: Colors.grey.shade600,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Bottom Section
              Padding(
                padding: const EdgeInsets.all(40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Indicators
                    Row(
                      children: List.generate(
                        _onboardingData.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 8),
                          height: 10,
                          width: _currentPage == index ? 35 : 10,
                          decoration: BoxDecoration(
                            gradient: _currentPage == index 
                                ? LinearGradient(colors: [Colors.orange.shade400, Colors.orange.shade800])
                                : null,
                            color: _currentPage == index ? null : Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: _currentPage == index ? [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ] : [],
                          ),
                        ),
                      ),
                    ),
                    
                    // Action Button
                    GestureDetector(
                      onTap: () {
                        if (_currentPage == _onboardingData.length - 1) {
                          Get.offAllNamed(AppRoutes.login);
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.orange.shade400, Colors.orange.shade800],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          _currentPage == _onboardingData.length - 1
                              ? Icons.check
                              : Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
