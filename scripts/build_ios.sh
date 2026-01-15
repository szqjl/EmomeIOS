#!/bin/bash

# EmoFirst iOS 构建脚本
# 用途：构建iOS Release版本

set -e

echo "🔨 开始构建 EmoFirst iOS Release 版本..."

# 进入项目目录
cd "$(dirname "$0")/.."

# 清理之前的构建
echo "🧹 清理之前的构建..."
flutter clean

# 获取依赖
echo "📦 获取依赖..."
flutter pub get

# 构建iOS Release
echo "🔨 构建 iOS Release..."
flutter build ios --release

echo ""
echo "✅ 构建完成！"
echo ""
echo "📝 下一步："
echo "   1. 在 Xcode 中打开: ios/Runner.xcworkspace"
echo "   2. 选择 Product -> Archive"
echo "   3. 验证并上传到 App Store Connect"
echo ""
