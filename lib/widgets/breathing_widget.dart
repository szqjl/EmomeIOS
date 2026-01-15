import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'dart:math';
import '../core/constants.dart';

enum BreathingPhase { breatheIn, hold, breatheOut }

class BreathingWidget extends StatefulWidget {
  final int cycle;
  final int totalCycles;

  const BreathingWidget({
    super.key,
    required this.cycle,
    required this.totalCycles,
  });

  @override
  State<BreathingWidget> createState() => _BreathingWidgetState();
}

class _BreathingWidgetState extends State<BreathingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  BreathingPhase _currentPhase = BreathingPhase.breatheIn;
  String _instructionText = AppTexts.breatheInText;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    );
    _startBreathingCycle();
  }

  void _startBreathingCycle() {
    _controller.reset();
    _controller.forward();
    
    // 吸气阶段（0-4秒）
    Future.delayed(const Duration(seconds: 0), () {
      if (mounted) {
        setState(() {
          _currentPhase = BreathingPhase.breatheIn;
          _instructionText = AppTexts.breatheInText;
        });
      }
    });

    // 屏息阶段（4-6秒）
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _currentPhase = BreathingPhase.hold;
          _instructionText = AppTexts.breatheHoldText;
        });
      }
    });

    // 呼气阶段（6-12秒）
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        setState(() {
          _currentPhase = BreathingPhase.breatheOut;
          _instructionText = AppTexts.breatheOutText;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _getBallSize() {
    final progress = _controller.value;
    if (_currentPhase == BreathingPhase.breatheIn) {
      // 0-4秒：100px → 180px
      return AppSizes.breathingBallMin +
          (AppSizes.breathingBallMax - AppSizes.breathingBallMin) *
              (progress * 4 / 12);
    } else if (_currentPhase == BreathingPhase.hold) {
      // 4-6秒：保持180px，轻微脉动
      return AppSizes.breathingBallMax +
          sin(progress * 2 * 3.14159) * 5;
    } else {
      // 6-12秒：180px → 100px
      final outProgress = (progress - 6 / 12) / (6 / 12);
      return AppSizes.breathingBallMax -
          (AppSizes.breathingBallMax - AppSizes.breathingBallMin) *
              outProgress;
    }
  }

  Color _getBallColor() {
    final progress = _controller.value;
    // 从红色渐变到蓝色
    return Color.lerp(
      AppColors.primaryRed,
      AppColors.breathingBlue,
      progress,
    )!;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 呼吸指示文字
            Text(
              _instructionText,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            
            SizedBox(height: 40.h),
            
            // 光球
            Container(
              width: _getBallSize().w,
              height: _getBallSize().w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getBallColor(),
                boxShadow: [
                  BoxShadow(
                    color: _getBallColor().withOpacity(0.5),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 60.h),
            
            // 进度指示
            Text(
              '${widget.cycle}/${widget.totalCycles}',
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        );
      },
    );
  }
}
