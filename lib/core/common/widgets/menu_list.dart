import 'package:easy/core/common/widgets/svg_widget.dart';
import 'package:easy/core/themes/app_pallete.dart';
import 'package:easy/core/common/entities/menu.dart';
import 'package:flutter/material.dart';

class MenuList extends StatelessWidget {
  final List<Menu> items;

  const MenuList({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final menu = items[index];
        return ElevatedButton(
          onPressed: menu.onTap,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            shadowColor: AppPallete.shadow,
          ),
          child: SvgWidget(
            menu.image,
            useDefaultColor: true,
            size: double.infinity,
          ),
        );
      },
    );
  }
}
