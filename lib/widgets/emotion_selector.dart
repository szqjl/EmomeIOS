import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/constants.dart';

class EmotionSelector extends StatefulWidget {
  final List<EmotionType> selectedEmotions;
  final Function(List<EmotionType>) onSelectionChanged;

  const EmotionSelector({
    super.key,
    required this.selectedEmotions,
    required this.onSelectionChanged,
  });

  @override
  State<EmotionSelector> createState() => _EmotionSelectorState();
}

class _EmotionSelectorState extends State<EmotionSelector> {
  List<EmotionType> _selectedEmotions = [];

  @override
  void initState() {
    super.initState();
    _selectedEmotions = List.from(widget.selectedEmotions);
  }

  void _toggleEmotion(EmotionType emotion) {
    setState(() {
      if (_selectedEmotions.contains(emotion)) {
        _selectedEmotions.remove(emotion);
      } else {
        if (_selectedEmotions.length < 3) {
          _selectedEmotions.add(emotion);
        }
      }
    });
    widget.onSelectionChanged(_selectedEmotions);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 情绪网格（2行3列）
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 1.2,
          ),
          itemCount: EmotionType.values.length,
          itemBuilder: (context, index) {
            final emotion = EmotionType.values[index];
            final isSelected = _selectedEmotions.contains(emotion);
            
            return GestureDetector(
              onTap: () => _toggleEmotion(emotion),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: Matrix4.identity()
                  ..scale(isSelected ? 1.2 : 1.0),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryRed.withOpacity(0.2)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryRed
                        : Colors.grey.withOpacity(0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      emotion.emoji,
                      style: TextStyle(fontSize: 32.sp),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      emotion.label,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        
        // 选中反馈
        if (_selectedEmotions.isNotEmpty) ...[
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.primaryRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '承认${_selectedEmotions.map((e) => e.label).join('、')}的感觉是OK的',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.primaryRed,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
