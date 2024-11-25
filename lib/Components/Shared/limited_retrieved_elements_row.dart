import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_tripper_mobile/Utilities/Retrievers/retriever.dart';


Widget LimitedRetrievedElementsRow(
    Set<String> elements,
    int elementNumber,
    SvgRetriever retriever, {
      double elementWidth = 25,
      Container Function(SvgPicture child)? wrapper,
      double lastItemBorderRadius = 0.0,
      double lastItemFontSize = 14.0,
      int rowHeight = 0
    }) {
  // Domyślny wrapper, jeśli żaden nie zostanie przekazany.
  wrapper ??= (child) => Container(child: child);

  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: List.generate(elementNumber, (index) {
      if (index < elements.length) {
        final SvgPicture elementWidget = retriever.retrieve(elements.elementAt(index), elementWidth);

        // Sprawdź, czy to ostatni element w przypadku > 5 elementów.
        if (index == elementNumber - 1 && elements.length > 5) {
          return Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Align(
                    alignment: Alignment.center, // Wyśrodkowanie elementu
                    child: SizedBox(
                      width: elementWidth, // Dopasowanie szerokości do `elementWidth`
                      child: wrapper!(elementWidget),
                    ),
                  ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center, // Wyśrodkowanie nakładki
                  child: SizedBox(
                    width: elementWidth, // Nakładka dopasowana do szerokości
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(lastItemBorderRadius),
                      ),
                      child: Center(
                        child: Text(
                          "+${elements.length - 5}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: lastItemFontSize,
                            fontWeight: FontWeight.w800,
                            fontFamily: "Source Sans 3"
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
                ],
              ),
            ),
          );
        }

        return Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.centerLeft,
            child: wrapper!(elementWidget),
          ),
        );
      }
      return const Expanded(flex: 1, child: SizedBox());
    }),
  );
}
