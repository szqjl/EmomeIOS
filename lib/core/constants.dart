import 'package:flutter/material.dart';

/// 应用颜色常量
class AppColors {
  // 主色调
  static const Color primaryRed = Color(0xFFFF6B6B);
  static const Color primaryRedDark = Color(0xFFFF5252);
  static const Color primaryRedLight = Color(0xFFFF3838);
  
  // 背景色
  static const Color backgroundGray = Color(0xFFF5F7FA);
  static const Color backgroundPink = Color(0xFFFFF5F5);
  static const Color backgroundBlue = Color(0xFFF5F9FF);
  
  // 文字颜色
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textWhite = Colors.white;
  
  // 呼吸引导颜色
  static const Color breathingBlue = Color(0xFF4D96FF);
}

/// 应用尺寸常量
class AppSizes {
  // 按钮尺寸
  static double get buttonWidth => 0.8; // 屏幕宽度的80%
  static double get buttonHeight => 0.4; // 屏幕高度的40%
  static double get buttonRadius => 24.0;
  
  // 文字尺寸
  static double get buttonTextSize => 32.0;
  static double get subtitleTextSize => 14.0;
  static double get titleTextSize => 24.0;
  
  // 间距
  static double get spacingSmall => 8.0;
  static double get spacingMedium => 16.0;
  static double get spacingLarge => 24.0;
  static double get spacingXLarge => 32.0;
  
  // 动画尺寸
  static double get heartAnimationSize => 150.0;
  static double get breathingBallMin => 100.0;
  static double get breathingBallMax => 180.0;
}

/// 应用时间常量
class AppDurations {
  // 核心流程时间
  static const int emotionTriggerDuration = 2300; // 2.3秒
  static const int releaseDuration = 10; // 10秒
  static const int calmingDuration = 20; // 20秒（3次呼吸，每次12秒，实际约36秒，但总流程20秒）
  
  // 动画时间
  static const int buttonPulseDuration = 3000; // 按钮脉动3秒
  static const int particleLifetime = 1500; // 粒子生命周期1.5秒
  
  // 呼吸周期
  static const int breatheInDuration = 4; // 吸气4秒
  static const int breatheHoldDuration = 2; // 屏息2秒
  static const int breatheOutDuration = 6; // 呼气6秒
  static const int breatheCycleDuration = 12; // 完整周期12秒
  static const int breatheCycleCount = 3; // 3次循环
}

/// 应用文本常量
class AppTexts {
  // 首页
  static const String homeButtonText = '被骂了';
  static const String homeSubtitleText = '给我30秒，快速平复';
  static const String homeButtonLoadingText = '正在释放...';
  
  // 释放阶段
  static const String releaseTitle = '释放中...';
  static const String releaseCompleteButton = '完成';
  
  // 平复阶段
  static const String breatheInText = '深吸气...';
  static const String breatheHoldText = '屏住呼吸...';
  static const String breatheOutText = '慢慢呼气...';
  static const String calmingCompleteText = '你做得很好';
  
  // 工具箱
  static const String toolboxTitle = '现在感觉好点了吗？';
  static const String toolboxPhraseCardTitle = '需要一些话语支持';
  static const String toolboxPhraseCardSubtitle = '找到适合表达的语句';
  static const String toolboxTip = '💡 情绪强烈时，重大决定可以等一等...';
}

/// 情绪类型
enum EmotionType {
  angry('愤怒', '😠'),
  wronged('委屈', '😢'),
  sad('伤心', '💔'),
  numb('麻木', '😶'),
  confused('混乱', '🌀'),
  stressed('压力', '😓');
  
  final String label;
  final String emoji;
  
  const EmotionType(this.label, this.emoji);
}

/// 话术分类
enum PhraseCategory {
  selfConfirmation('自我确认'),
  gentleBoundary('温和边界'),
  situationResponse('情境应对');
  
  final String label;
  
  const PhraseCategory(this.label);
}

/// 话术数据
class PhraseData {
  static const List<String> selfConfirmation = [
    '我的感受是真实的。',
    '我允许自己现在不舒服。',
    '这不是我的错。',
  ];
  
  static const List<String> gentleBoundary = [
    '我需要一点空间来处理。',
    '我们稍后再谈这个话题好吗？',
    '这样说我感到不舒服。',
  ];
  
  static const List<String> situationResponse = [
    '对于刚才的事情，我们可能需要更冷静地讨论。',
  ];
}
