import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/constants.dart';

class PhraseCard extends StatelessWidget {
  final String phrase;
  final PhraseCategory category;

  const PhraseCard({
    super.key,
    required this.phrase,
    required this.category,
  });

  Future<void> _copyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: phrase));
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('已复制到剪贴板'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
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
          // 话术内容
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Text(
              phrase,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
          
          // 分隔线
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey.withOpacity(0.2),
          ),
          
          // 复制按钮
          InkWell(
            onTap: () => _copyToClipboard(context),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: Container(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Icon(
                    Icons.copy,
                    size: 20.sp,
                    color: AppColors.primaryRed,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '一键复制',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.primaryRed,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
