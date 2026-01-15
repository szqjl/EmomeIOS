import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import '../core/constants.dart';
import '../widgets/particle_system.dart';
import '../core/session_manager.dart';
import 'calming_screen.dart';

enum SoundEffect { bubble, windChime, fire }

class ReleaseScreen extends StatefulWidget {
  const ReleaseScreen({super.key});

  @override
  State<ReleaseScreen> createState() => _ReleaseScreenState();
}

class _ReleaseScreenState extends State<ReleaseScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<Particle> _particles = [];
  SoundEffect _currentSound = SoundEffect.bubble;
  int _remainingTime = AppDurations.releaseDuration;
  bool _isCompleted = false;
  Timer? _countdownTimer;
  Timer? _particleUpdateTimer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _startParticleUpdate();
  }

  void _startParticleUpdate() {
    _particleUpdateTimer = Timer.periodic(
      const Duration(milliseconds: 16), // 60fps
      (timer) {
        if (mounted && !_isCompleted) {
          setState(() {
            for (final particle in _particles) {
              particle.update(0.016); // 16ms = 0.016秒
            }
            _particles.removeWhere((p) => !p.isAlive);
          });
        }
      },
    );
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (mounted && !_isCompleted) {
          setState(() {
            _remainingTime--;
          });
          if (_remainingTime <= 0) {
            timer.cancel();
            _completeRelease();
          }
        } else {
          timer.cancel();
        }
      },
    );
  }

  void _completeRelease() {
    if (_isCompleted) return;
    _isCompleted = true;
    
    // 更新会话数据
    SessionManager().updateReleaseDuration(AppDurations.releaseDuration);
    
    // 跳转到平复页面
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const CalmingScreen(),
      ),
    );
  }

  void _handleTap(TapDownDetails details) {
    final position = details.localPosition;
    
    // 触觉反馈
    HapticFeedback.lightImpact();
    
    // 播放音效
    _playSoundEffect();
    
    // 在点击位置创建新粒子
    setState(() {
      _particles.add(Particle(
        x: position.dx,
        y: position.dy,
      ));
    });
  }

  Future<void> _playSoundEffect() async {
    try {
      String assetPath;
      switch (_currentSound) {
        case SoundEffect.bubble:
          // 随机播放泡泡音效
          final random = DateTime.now().millisecond % 3;
          assetPath = 'audio/bubble_pop_${random + 1}.mp3';
          break;
        case SoundEffect.windChime:
          // 每3次点击播放一个音符
          if (_particles.length % 3 == 0) {
            final note = (_particles.length ~/ 3) % 3;
            assetPath = 'audio/wind_chime_${note + 1}.mp3';
          } else {
            return; // 跳过此次播放
          }
          break;
        case SoundEffect.fire:
          assetPath = 'audio/fire_crackle.mp3';
          break;
      }
      await _audioPlayer.play(AssetSource(assetPath));
    } catch (e) {
      // 开发阶段静默失败
      debugPrint('Audio error: $e');
    }
  }

  void _switchSoundEffect() {
    setState(() {
      _currentSound = SoundEffect.values[
        (_currentSound.index + 1) % SoundEffect.values.length
      ];
    });
  }

  String _getSoundIcon() {
    switch (_currentSound) {
      case SoundEffect.bubble:
        return '💧';
      case SoundEffect.windChime:
        return '🔔';
      case SoundEffect.fire:
        return '🔥';
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _particleUpdateTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: SafeArea(
        child: Stack(
          children: [
            // 粒子系统
            GestureDetector(
              onTapDown: _handleTap,
              child: CustomPaint(
                painter: ParticlePainter(_particles),
                size: Size.infinite,
              ),
            ),
            
            // 顶部倒计时
            Positioned(
              top: 40.h,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  '${AppTexts.releaseTitle} $_remainingTime',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            
            // 右下角音效切换
            Positioned(
              bottom: 100.h,
              right: 24.w,
              child: GestureDetector(
                onTap: _switchSoundEffect,
                child: Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _getSoundIcon(),
                      style: TextStyle(fontSize: 24.sp),
                    ),
                  ),
                ),
              ),
            ),
            
            // 底部完成按钮
            Positioned(
              bottom: 40.h,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: _completeRelease,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.w,
                      vertical: 16.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    AppTexts.releaseCompleteButton,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
