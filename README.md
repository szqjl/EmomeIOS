# EmoFirst iOS 开发项目

## 快速开始

### 1. 环境要求
- Flutter >= 3.16.0
- Xcode >= 14.0
- CocoaPods >= 1.11.0
- iOS 14.0+

### 2. 安装依赖
```bash
flutter pub get
cd ios && pod install && cd ..
```

### 3. 运行项目
```bash
# 开发模式
flutter run

# iOS模拟器
flutter run -d ios

# 真机调试
flutter run -d <device-id>
```

### 4. 构建Release
```bash
# iOS构建
flutter build ios --release
```

## 项目结构

详见 `iOS开发工作流.md` 文件。

## 开发阶段

当前阶段：**阶段1 - 核心框架搭建**

## 功能清单（方案A：极简版）

### ✅ 核心流程（32.3秒）
- [x] 首页："被骂了"按钮
- [ ] 情绪启动动画（2.3秒）
- [ ] 释放阶段（10秒）
- [ ] 平复阶段（20秒）

### ✅ 工具箱（极简版）
- [ ] 情绪标记（6种情绪）
- [ ] 话术库（3个分类）

### ⏸️ 后置功能（V1.5）
- [ ] 事实记录本（简化版）

## 技术栈

- Flutter 3.16
- Riverpod 2.0
- Lottie 6.0
- Hive 2.0
- audioplayers 5.0
- vibration 1.7.5

## 开发规范

- 遵循 Flutter 官方代码规范
- 使用 `dart format` 格式化代码
- Git提交使用约定式提交格式

## 相关文档

- [iOS开发工作流.md](./iOS开发工作流.md) - 详细开发流程
- [EmoFirst 情绪急救箱 - 产品研发文档.md](../EmoFirst%20情绪急救箱%20-%20产品研发文档.md) - 产品文档
- [EmoFirst 精简改进分析报告.md](../EmoFirst%20精简改进分析报告.md) - 精简方案
