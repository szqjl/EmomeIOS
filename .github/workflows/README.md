# GitHub Actions 工作流说明

## 📋 工作流概览

本项目配置了两个 GitHub Actions 工作流：

### 1. iOS Build (`ios-build.yml`)
**用途**：在 macOS 环境中自动构建 iOS 应用

**触发条件**：
- 推送到 `main` 或 `develop` 分支
- 创建 Pull Request 到 `main` 或 `develop` 分支
- 手动触发（workflow_dispatch）

**构建步骤**：
1. ✅ 检出代码
2. ✅ 设置 Flutter 环境（3.16.0）
3. ✅ 获取依赖
4. ✅ 安装 CocoaPods 依赖
5. ✅ 构建 iOS Debug 版本
6. ✅ 构建 iOS Release 版本
7. ✅ 创建 Xcode Archive
8. ✅ 上传构建产物

**构建产物**：
- `Runner.xcarchive` - Xcode Archive 文件
- `Runner.app` - iOS 应用包

**下载方式**：
1. 进入 GitHub Actions 页面
2. 选择对应的构建任务
3. 在 "Artifacts" 部分下载 `ios-build-artifacts`

---

### 2. Flutter Test (`flutter-test.yml`)
**用途**：运行代码分析和测试

**触发条件**：
- 推送到 `main` 或 `develop` 分支
- 创建 Pull Request
- 手动触发

**测试步骤**：
1. ✅ 检出代码
2. ✅ 设置 Flutter 环境
3. ✅ 获取依赖
4. ✅ 代码分析（`flutter analyze`）
5. ✅ 运行测试（`flutter test`）

---

## 🚀 使用方法

### 方法1：自动触发
1. 将代码推送到 GitHub 仓库
2. GitHub Actions 会自动触发构建
3. 在 Actions 标签页查看构建进度

### 方法2：手动触发
1. 进入 GitHub 仓库
2. 点击 "Actions" 标签页
3. 选择对应的工作流
4. 点击 "Run workflow" 按钮
5. 选择分支并运行

---

## 📱 构建产物使用

### 下载构建产物
1. 进入 GitHub Actions 页面
2. 选择已完成的构建任务
3. 滚动到页面底部
4. 在 "Artifacts" 部分下载 `ios-build-artifacts`

### 使用构建产物
- **Runner.xcarchive**：可以在 Xcode 中打开，用于导出 .ipa 文件
- **Runner.app**：可以直接安装到 iOS 设备（需要签名）

---

## ⚙️ 配置说明

### 代码签名
当前配置使用 `--no-codesign` 参数，因为：
- GitHub Actions 的免费 runner 不包含 Apple Developer 证书
- 需要代码签名时，需要配置 GitHub Secrets

### 配置代码签名（可选）
如果需要代码签名，需要：

1. **添加 GitHub Secrets**：
   - `APPLE_CERTIFICATE_BASE64` - 证书文件（Base64 编码）
   - `APPLE_CERTIFICATE_PASSWORD` - 证书密码
   - `APPLE_PROVISIONING_PROFILE_BASE64` - 描述文件（Base64 编码）
   - `APPLE_TEAM_ID` - Apple Team ID

2. **修改工作流**：
   在构建步骤中添加代码签名配置

---

## 🔧 自定义配置

### 修改 Flutter 版本
在 `ios-build.yml` 中修改：
```yaml
flutter-version: '3.16.0'  # 改为你需要的版本
```

### 修改触发分支
在 `on.push.branches` 中添加或修改分支：
```yaml
branches:
  - main
  - develop
  - your-branch  # 添加你的分支
```

### 修改构建配置
在构建步骤中修改参数：
```yaml
run: flutter build ios --release --no-codesign
```

---

## 📊 构建状态

构建状态会显示在：
- GitHub Actions 页面
- Pull Request 页面（如果配置了状态检查）
- 仓库主页（如果配置了状态徽章）

---

## 🐛 故障排除

### 构建失败
1. 检查 Flutter 版本是否匹配
2. 检查依赖是否正确安装
3. 查看构建日志中的错误信息

### 依赖安装失败
1. 检查 `pubspec.yaml` 配置
2. 检查网络连接
3. 尝试清理缓存后重新构建

### CocoaPods 问题
1. 检查 `ios/Podfile` 配置
2. 尝试更新 CocoaPods：`pod repo update`

---

## 📚 相关文档

- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [Flutter CI/CD 文档](https://docs.flutter.dev/deployment/cd)
- [iOS 构建文档](https://docs.flutter.dev/deployment/ios)

---

**配置时间**：2025年1月15日  
**Flutter 版本**：3.16.0  
**构建平台**：macOS Latest
