import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/constants.dart';
import 'release_screen.dart';

class EmotionTriggerScreen extends StatefulWidget {
  const EmotionTriggerScreen({super.key});

  @override
  State<EmotionTriggerScreen> createState() => _EmotionTriggerScreenState();
}

class _EmotionTriggerScreenState extends State<EmotionTriggerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _animationCompleted = false;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  Future<void> _startAnimation() async {
    // 播放音效（压力积聚声）
    try {
      await _audioPlayer.play(AssetSource('audio/pressurebuild.mp3'));
    } catch (e) {
      // 如果音频文件不存在，静默失败（开发阶段）
      debugPrint('Audio file not found: $e');
    }

    // 1.8秒后触发震动
    Future.delayed(const Duration(milliseconds: 1800), () async {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 500); // iOS中等强度震动
      }
    });

    // 2.3秒后跳转到释放页面
    Future.delayed(const Duration(milliseconds: 2300), () {
      if (mounted && !_animationCompleted) {
        _animationCompleted = true;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ReleaseScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: AppSizes.heartAnimationSize.w,
            height: AppSizes.heartAnimationSize.h,
            child: Image.asset(
              'assets/animations/心形碎裂动画.gif',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
