import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/constants.dart';
import '../core/session_manager.dart';
import 'emotion_trigger_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // 按钮脉动动画（每3秒缩放101%）
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);
    
    // 初始化会话
    SessionManager().startSession();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _handleButtonTap() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });
    
    // 触觉反馈
    HapticFeedback.mediumImpact();
    
    // 短暂延迟后跳转
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (!mounted) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EmotionTriggerScreen(),
      ),
    ).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 主按钮
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final scale = 1.0 + (_pulseController.value * 0.01);
                  return Transform.scale(
                    scale: _isLoading ? 0.95 : scale,
                    child: GestureDetector(
                      onTap: _handleButtonTap,
                      child: Container(
                        width: MediaQuery.of(context).size.width * AppSizes.buttonWidth,
                        height: MediaQuery.of(context).size.height * AppSizes.buttonHeight,
                        decoration: BoxDecoration(
                          color: _isLoading 
                              ? AppColors.primaryRedDark 
                              : AppColors.primaryRed,
                          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryRed.withOpacity(0.3),
                              offset: const Offset(0, 4),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: Center(
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: AppColors.textWhite,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  _isLoading 
                                      ? AppTexts.homeButtonLoadingText 
                                      : AppTexts.homeButtonText,
                                  style: TextStyle(
                                    fontSize: AppSizes.buttonTextSize.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textWhite,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              
              // 副文案
              SizedBox(height: 20.h),
              Text(
                AppTexts.homeSubtitleText,
                style: TextStyle(
                  fontSize: AppSizes.subtitleTextSize.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
