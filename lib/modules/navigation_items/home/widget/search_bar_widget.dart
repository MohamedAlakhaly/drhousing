import 'dart:async';

import 'package:apartment_rentals/core/functions/helper_functions.dart';
import 'package:apartment_rentals/modules/navigation_items/home/controller/apartment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final ApartmentController _controller = Get.find();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _textController.text = _controller.searchQuery.value;
    _focusNode.addListener(() {
      setState(() => _hasFocus = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _controller.searchQuery.value = value;
    });
    setState(() {});
  }

  void _clear() {
    _textController.clear();
    _controller.searchQuery.value = '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final hasText = _textController.text.isNotEmpty;
    bool isDarkMode = HelperFunctions.isDarkMode(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF1E1E1E) : Colors.grey[300],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDarkMode
              ? _hasFocus
                    ? Color(0xFFCCFF00)
                    : Colors.transparent
              : Colors.grey.shade400.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: _textController,
        focusNode: _focusNode,
        onChanged: _onChanged,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: 'Satoshi',
        ),
        cursorColor: isDarkMode? Color(0xFFCCFF00):Colors.grey[800],
        cursorWidth: 2,
        decoration: InputDecoration(
          hintText: 'search_by_city'.tr,
          hintStyle: const TextStyle(
            color: Color(0xFF888888),
            fontSize: 14,
            fontFamily: 'Satoshi',
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Color(0xFF888888),
            size: 20,
          ),
          suffixIcon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: hasText
                ? GestureDetector(
                    key: const ValueKey('clear'),
                    onTap: _clear,
                    child: const Icon(
                      Icons.close_rounded,
                      color: Color(0xFF888888),
                      size: 18,
                    ),
                  )
                : const SizedBox.shrink(key: ValueKey('empty')),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
