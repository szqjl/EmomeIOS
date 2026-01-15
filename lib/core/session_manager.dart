import 'dart:async';
import 'models/emotion.dart';

/// 会话管理器 - 仅内存存储
/// 关闭应用即丢失所有数据
class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  // 会话数据（仅内存）
  Map<String, dynamic> _sessionData = {};
  Timer? _cleanupTimer;

  /// 开始新会话
  void startSession() {
    _sessionData = {
      'startTime': DateTime.now(),
      'selectedEmotions': <EmotionType>[],
      'releaseDuration': 0,
      'calmingCompleted': false,
      'toolUsed': <String>[],
    };
  }

  /// 更新选中的情绪
  void updateSelectedEmotions(List<EmotionType> emotions) {
    _sessionData['selectedEmotions'] = emotions;
  }

  /// 更新释放时长
  void updateReleaseDuration(int duration) {
    _sessionData['releaseDuration'] = duration;
  }

  /// 标记平复完成
  void markCalmingCompleted() {
    _sessionData['calmingCompleted'] = true;
  }

  /// 记录使用的工具
  void addToolUsed(String toolName) {
    final tools = _sessionData['toolUsed'] as List<String>;
    if (!tools.contains(toolName)) {
      tools.add(toolName);
    }
  }

  /// 获取会话数据
  Map<String, dynamic> getSessionData() {
    return Map.from(_sessionData);
  }

  /// 设置自动清理（应用进入后台10分钟后清理）
  void setupAutoCleanup() {
    // 注意：在Flutter中，需要使用WidgetsBindingObserver来监听应用生命周期
    // 这里提供一个接口，实际实现需要在Widget中监听
  }

  /// 清理会话数据
  void clearSession() {
    _sessionData.clear();
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
  }

  /// 手动触发清理（用于测试或手动重置）
  void cleanup() {
    clearSession();
  }
}
