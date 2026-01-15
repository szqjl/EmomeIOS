import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/constants.dart';
import '../widgets/breathing_widget.dart';
import '../core/session_manager.dart';
import 'toolbox_screen.dart';

class CalmingScreen extends StatefulWidget {
  const CalmingScreen({super.key});

  @override
  State<CalmingScreen> createState() => _CalmingScreenState();
}

class _CalmingScreenState extends State<CalmingScreen> {
  int _currentCycle = 0;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _startBreathing();
  }

  void _startBreathing() {
    // 3次呼吸循环，每次12秒
    Future.delayed(const Duration(seconds: 12), () {
      if (mounted) {
        setState(() {
          _currentCycle++;
        });
        if (_currentCycle < AppDurations.breatheCycleCount) {
          _startBreathing();
        } else {
          _completeCalming();
        }
      }
    });
  }

  void _completeCalming() {
    if (_isCompleted) return;
    _isCompleted = true;
    
    // 更新会话数据
    SessionManager().markCalmingCompleted();
    
    // 显示完成提示
    setState(() {});
    
    // 3秒后跳转到工具箱
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ToolboxScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _isCompleted
                ? [AppColors.backgroundGray, AppColors.backgroundGray]
                : [
                    AppColors.backgroundPink,
                    AppColors.backgroundBlue,
                  ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: _isCompleted
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppTexts.calmingCompleteText,
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BreathingWidget(
                        cycle: _currentCycle + 1,
                        totalCycles: AppDurations.breatheCycleCount,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
