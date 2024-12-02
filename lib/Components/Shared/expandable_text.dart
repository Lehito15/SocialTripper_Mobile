import 'package:flutter/material.dart';


class ExpandableDescriptionText extends StatefulWidget {
  final String description;
  final TextStyle? textStyle;  // Parametr opcjonalny dla stylu tekstu
  final int maxLines;         // Parametr dla maxLines, domyślnie 5

  ExpandableDescriptionText({
    required this.description,
    required this.textStyle,
    this.maxLines = 5,  // Domyślna wartość maxLines to 5
  });

  @override
  _ExpandableDescriptionTextState createState() =>
      _ExpandableDescriptionTextState();
}

class _ExpandableDescriptionTextState extends State<ExpandableDescriptionText> {
  bool _isExpanded = false;

  // Funkcja do obliczenia liczby linii
  bool isTextOverflowing(BuildContext context) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.description,
        style: widget.textStyle,  // Używamy przekazanego stylu
      ),
      maxLines: widget.maxLines, // Używamy przekazanej wartości maxLines
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: MediaQuery.of(context).size.width);

    return textPainter.didExceedMaxLines; // Zwraca true, jeśli tekst przekracza maxLines
  }

  @override
  Widget build(BuildContext context) {
    // Sprawdzamy, czy tekst przekracza maxLines
    bool isOverflowing = isTextOverflowing(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.description,
          textAlign: TextAlign.left,
          style: widget.textStyle, // Używamy przekazanego stylu
          maxLines: _isExpanded ? null : widget.maxLines, // Używamy przekazanego maxLines
          overflow: _isExpanded ? null : TextOverflow.ellipsis,
        ),
        if (isOverflowing)
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(
              _isExpanded ? "Show less" : "Show more",
              style: widget.textStyle?.copyWith(color: Colors.black, fontWeight: FontWeight.bold), // Używamy przekazanego stylu, zmieniając tylko kolor
            ),
          ),
      ],
    );
  }
}
