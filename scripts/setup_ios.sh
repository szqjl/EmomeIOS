#!/bin/bash

# EmoFirst iOS 项目设置脚本
# 用途：自动配置iOS开发环境

set -e

echo "🚀 开始配置 EmoFirst iOS 项目..."

# 检查Flutter环境
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter 未安装，请先安装 Flutter"
    exit 1
fi

echo "✅ Flutter 环境检查通过"

# 检查iOS开发环境
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Xcode 未安装，请先安装 Xcode"
    exit 1
fi

echo "✅ Xcode 环境检查通过"

# 进入项目目录
cd "$(dirname "$0")/.."

# 获取Flutter依赖
echo "📦 获取 Flutter 依赖..."
flutter pub get

# 进入iOS目录
cd ios

# 安装CocoaPods依赖
if command -v pod &> /dev/null; then
    echo "📦 安装 CocoaPods 依赖..."
    pod install
else
    echo "⚠️  CocoaPods 未安装，跳过 pod install"
    echo "   请手动运行: cd ios && pod install"
fi

# 返回项目根目录
cd ..

echo ""
echo "✅ iOS 项目配置完成！"
echo ""
echo "📝 下一步："
echo "   1. 在 Xcode 中打开: ios/Runner.xcworkspace"
echo "   2. 配置 Bundle ID: com.emofirst"
echo "   3. 设置开发团队和签名"
echo "   4. 添加 App 图标"
echo "   5. 运行项目: flutter run -d ios"
echo ""
