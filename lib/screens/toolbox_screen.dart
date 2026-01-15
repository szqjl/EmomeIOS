import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/constants.dart';
import '../widgets/emotion_selector.dart';
import '../widgets/phrase_card.dart';
import '../core/session_manager.dart';

class ToolboxScreen extends StatefulWidget {
  const ToolboxScreen({super.key});

  @override
  State<ToolboxScreen> createState() => _ToolboxScreenState();
}

class _ToolboxScreenState extends State<ToolboxScreen> {
  List<EmotionType> _selectedEmotions = [];
  bool _showTip = false;

  @override
  void initState() {
    super.initState();
    // 3分钟后显示提示
    Future.delayed(const Duration(minutes: 3), () {
      if (mounted) {
        setState(() {
          _showTip = true;
        });
      }
    });
  }

  void _handleEmotionSelected(List<EmotionType> emotions) {
    setState(() {
      _selectedEmotions = emotions;
    });
    // 更新会话数据
    SessionManager().updateSelectedEmotions(emotions);
    SessionManager().addToolUsed('emotion_selector');
  }

  void _handlePhraseCardTap() {
    SessionManager().addToolUsed('phrase_library');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PhraseLibraryScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 顶部标题
              Text(
                AppTexts.toolboxTitle,
                style: TextStyle(
                  fontSize: AppSizes.titleTextSize.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              
              SizedBox(height: 32.h),
              
              // 情绪标记区域
              EmotionSelector(
                selectedEmotions: _selectedEmotions,
                onSelectionChanged: _handleEmotionSelected,
              ),
              
              SizedBox(height: 40.h),
              
              // 功能卡片（仅1个：话术库）
              GestureDetector(
                onTap: _handlePhraseCardTap,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '💬',
                            style: TextStyle(fontSize: 32.sp),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppTexts.toolboxPhraseCardTitle,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  AppTexts.toolboxPhraseCardSubtitle,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // 底部提示（3分钟后显示）
              if (_showTip) ...[
                SizedBox(height: 40.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.amber.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        AppTexts.toolboxTip,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// 话术库页面
class PhraseLibraryScreen extends StatefulWidget {
  const PhraseLibraryScreen({super.key});

  @override
  State<PhraseLibraryScreen> createState() => _PhraseLibraryScreenState();
}

class _PhraseLibraryScreenState extends State<PhraseLibraryScreen> {
  PhraseCategory _selectedCategory = PhraseCategory.selfConfirmation;

  List<String> _getPhrases() {
    switch (_selectedCategory) {
      case PhraseCategory.selfConfirmation:
        return PhraseData.selfConfirmation;
      case PhraseCategory.gentleBoundary:
        return PhraseData.gentleBoundary;
      case PhraseCategory.situationResponse:
        return PhraseData.situationResponse;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      appBar: AppBar(
        title: const Text('话术库'),
        backgroundColor: AppColors.backgroundGray,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 分类标签栏
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: PhraseCategory.values.map((category) {
                final isSelected = _selectedCategory == category;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryRed
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          category.label,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? AppColors.textWhite
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          // 话术列表
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.w),
              itemCount: _getPhrases().length,
              itemBuilder: (context, index) {
                final phrase = _getPhrases()[index];
                return PhraseCard(
                  phrase: phrase,
                  category: _selectedCategory,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
