import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:product_browser_app/core/theming/colors.dart';
import 'package:product_browser_app/core/theming/styles.dart';
import 'package:product_browser_app/features/chat/presentation/bloc/chat_bloc/chat_bloc.dart';

class ChatInputBar extends StatefulWidget {
  final String productId;
  final VoidCallback onSent;

  const ChatInputBar({
    super.key,
    required this.productId,
    required this.onSent,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<ChatBloc>().add(
      SendMessage(productId: widget.productId, text: text),
    );
    _controller.clear();
    widget.onSent();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 8.w, 8.h),
      decoration: BoxDecoration(
        color: ColorsManager.backgroundWhite,
        border: Border(top: BorderSide(color: ColorsManager.moreLightGray)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                maxLength: 500,
                controller: _controller,
                decoration: InputDecoration(
                  counterText: '',
                  hintText: 'Write a message…',
                  hintStyle: TextStyles.font15GrayRegular.copyWith(
                    color: ColorsManager.lightGray,
                  ),
                  filled: true,
                  fillColor: ColorsManager.moreLighterGray,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyles.font15GrayRegular.copyWith(
                  color: ColorsManager.darkBlue,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: _send,
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: ColorsManager.mainIndigo,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.send, color: Colors.white, size: 18.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
