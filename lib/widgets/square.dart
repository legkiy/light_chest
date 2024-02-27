import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:light_chest/widgets/widgets.dart';

class Square extends StatelessWidget {
  final bool isWhite;
  final ChestFig? figure;
  final bool isSelected;
  final bool isValidMove;
  final void Function()? onTap;

  const Square({
    super.key,
    required this.isWhite,
    required this.figure,
    required this.isSelected,
    required this.isValidMove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color? selectSquare;
    if (isSelected) {
      selectSquare = Colors.green;
    } else if (isValidMove) {
      selectSquare = Colors.green[300];
    } else {
      selectSquare = isWhite ? Colors.grey.shade400 : Colors.grey.shade700;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: selectSquare,
        child: figure != null
            ? SvgPicture.asset(
                figure!.imgPath,
                colorFilter: ColorFilter.mode(
                  figure!.isWhite ? Colors.white : Colors.black,
                  BlendMode.srcIn,
                ),
                allowDrawingOutsideViewBox: true,
              )
            : null,
      ),
    );
  }
}
