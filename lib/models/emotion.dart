import '../core/constants.dart';

/// 情绪数据模型
class Emotion {
  final EmotionType type;
  final DateTime selectedAt;
  
  Emotion({
    required this.type,
    required this.selectedAt,
  });
  
  String get label => type.label;
  String get emoji => type.emoji;
  
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'selectedAt': selectedAt.toIso8601String(),
    };
  }
  
  factory Emotion.fromJson(Map<String, dynamic> json) {
    return Emotion(
      type: EmotionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => EmotionType.sad,
      ),
      selectedAt: DateTime.parse(json['selectedAt']),
    );
  }
}
