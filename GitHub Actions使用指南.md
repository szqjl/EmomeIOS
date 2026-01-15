# GitHub Actions 使用指南

## 🎯 概述

本项目已配置 GitHub Actions，可以在 Windows 上开发，然后在云端 macOS 环境中自动构建 iOS 应用。

---

## 🚀 快速开始

### 1. 将代码推送到 GitHub

```bash
# 初始化 Git 仓库（如果还没有）
cd 开发工作流
git init

# 添加远程仓库
git remote add origin https://github.com/你的用户名/你的仓库名.git

# 添加文件
git add .

# 提交
git commit -m "初始提交：配置 GitHub Actions"

# 推送到 GitHub
git push -u origin main
```

### 2. 查看构建进度

1. 进入 GitHub 仓库页面
2. 点击 "Actions" 标签页
3. 查看构建进度和结果

### 3. 下载构建产物

1. 在 Actions 页面选择已完成的构建任务
2. 滚动到页面底部
3. 在 "Artifacts" 部分下载 `ios-build-artifacts`

---

## 📋 工作流说明

### iOS Build 工作流

**文件位置**：`.github/workflows/ios-build.yml`

**功能**：
- ✅ 自动构建 iOS Debug 版本
- ✅ 自动构建 iOS Release 版本
- ✅ 创建 Xcode Archive
- ✅ 上传构建产物

**触发条件**：
- 推送到 `main` 或 `develop` 分支
- 创建 Pull Request
- 手动触发

**构建时间**：约 10-15 分钟

### Flutter Test 工作流

**文件位置**：`.github/workflows/flutter-test.yml`

**功能**：
- ✅ 代码分析（`flutter analyze`）
- ✅ 运行测试（`flutter test`）

**触发条件**：
- 推送到 `main` 或 `develop` 分支
- 创建 Pull Request
- 手动触发

---

## 🔧 手动触发构建

### 方法1：通过 GitHub 网页

1. 进入 GitHub 仓库
2. 点击 "Actions" 标签页
3. 选择 "iOS Build" 工作流
4. 点击 "Run workflow" 按钮
5. 选择分支并运行

### 方法2：通过 GitHub CLI

```bash
# 安装 GitHub CLI（如果还没有）
# Windows: winget install GitHub.cli

# 登录
gh auth login

# 触发工作流
gh workflow run ios-build.yml
```

---

## 📱 使用构建产物

### 下载构建产物

构建完成后，可以在 Actions 页面下载：
- `Runner.xcarchive` - Xcode Archive 文件
- `Runner.app` - iOS 应用包

### 使用 Runner.xcarchive

1. 下载 `ios-build-artifacts.zip`
2. 解压文件
3. 在 macOS 上打开 `Runner.xcarchive`
4. 在 Xcode 中导出 .ipa 文件

### 使用 Runner.app

**注意**：需要代码签名才能安装到设备

1. 下载构建产物
2. 在 macOS 上使用 Xcode 进行代码签名
3. 通过 Xcode 或 TestFlight 安装到设备

---

## ⚙️ 配置代码签名（可选）

如果需要自动代码签名，需要配置 GitHub Secrets：

### 1. 准备证书和描述文件

- Apple Developer 证书（.p12 文件）
- Provisioning Profile（.mobileprovision 文件）
- Apple Team ID

### 2. 添加 GitHub Secrets

1. 进入 GitHub 仓库
2. 点击 "Settings" → "Secrets and variables" → "Actions"
3. 点击 "New repository secret"
4. 添加以下 Secrets：
   - `APPLE_CERTIFICATE_BASE64` - 证书文件（Base64 编码）
   - `APPLE_CERTIFICATE_PASSWORD` - 证书密码
   - `APPLE_PROVISIONING_PROFILE_BASE64` - 描述文件（Base64 编码）
   - `APPLE_TEAM_ID` - Apple Team ID

### 3. 修改工作流文件

在 `.github/workflows/ios-build.yml` 中添加代码签名步骤。

---

## 🐛 故障排除

### 构建失败

**问题**：构建任务失败

**解决方案**：
1. 查看构建日志，找到错误信息
2. 检查 Flutter 版本是否匹配
3. 检查依赖是否正确
4. 尝试清理缓存后重新构建

### 依赖安装失败

**问题**：`flutter pub get` 失败

**解决方案**：
1. 检查 `pubspec.yaml` 配置
2. 检查网络连接
3. 尝试更新依赖版本

### CocoaPods 问题

**问题**：`pod install` 失败

**解决方案**：
1. 检查 `ios/Podfile` 配置
2. 检查 iOS 部署目标版本
3. 查看详细错误日志

---

## 📊 构建状态徽章

可以在 README.md 中添加构建状态徽章：

```markdown
![iOS Build](https://github.com/你的用户名/你的仓库名/workflows/iOS%20Build/badge.svg)
![Flutter Test](https://github.com/你的用户名/你的仓库名/workflows/Flutter%20Test/badge.svg)
```

---

## 💡 最佳实践

### 1. 分支策略

- `main` 分支：生产环境代码
- `develop` 分支：开发环境代码
- `feature/*` 分支：功能开发

### 2. 提交规范

使用清晰的提交信息：
```
feat: 添加新功能
fix: 修复bug
docs: 更新文档
build: 构建配置
```

### 3. 定期构建

- 每次推送代码时自动构建
- 重要功能完成后手动触发构建
- 发布前进行完整测试

---

## 📚 相关资源

- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [Flutter CI/CD 指南](https://docs.flutter.dev/deployment/cd)
- [iOS 构建文档](https://docs.flutter.dev/deployment/ios)

---

## ✅ 配置检查清单

- [x] GitHub Actions 工作流文件已创建
- [x] iOS 构建工作流已配置
- [x] Flutter 测试工作流已配置
- [x] 构建产物上传已配置
- [ ] 代码已推送到 GitHub
- [ ] 构建任务已成功运行
- [ ] 构建产物已成功下载

---

**配置完成时间**：2025年1月15日  
**Flutter 版本**：3.16.0  
**构建平台**：macOS Latest  
**免费额度**：2000 分钟/月（GitHub Free）
