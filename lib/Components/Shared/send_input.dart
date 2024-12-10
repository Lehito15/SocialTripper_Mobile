import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_tripper_mobile/Components/Shared/bordered_user_picture.dart';
import 'package:social_tripper_mobile/Models/Account/account.dart';
import 'package:social_tripper_mobile/Models/Account/account_thumbnail.dart';

import '../../Utilities/Retrievers/icon_retriever.dart';

class SendInput extends StatefulWidget {
  final Future<AccountThumbnail> authorFuture;
  final Future<void> Function(String) onSend; // Callback do obsługi wysyłania tekstu
  final String hintText; // Placeholder w polu tekstowym

  const SendInput({
    Key? key,
    required this.onSend,
    this.hintText = 'Enter text...',
    required this.authorFuture,
  }) : super(key: key);

  @override
  State<SendInput> createState() => _SendInputState();
}

class _SendInputState extends State<SendInput> {
  final TextEditingController _controller = TextEditingController();
  AccountThumbnail? author;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
    }
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
      fontSize: 14,
      fontFamily: "Source Sans 3",
      fontWeight: FontWeight.w400,
      color: Colors.black.withOpacity(0.5),
    );

    return Row(
      children: [
        // Użycie FutureBuilder do obsługi załadowania autora
        author == null ? FutureBuilder<AccountThumbnail>(
          future: widget.authorFuture, // Przypisanie przyszłości do załadowania autora
          builder: (context, snapshot) {
            // Sprawdzanie stanu połączenia
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Wyświetlenie domyślnego obrazka podczas ładowania
              return BorderedUserPicture(
                radius: 34,
                pictureURI: "assets/icons/zbigniew.jpg", // Ścieżka do domyślnego obrazka
              );
            } else if (snapshot.hasError) {
              // Jeśli wystąpił błąd, pokaż ikonę błędu
              return Icon(Icons.error);
            } else if (snapshot.hasData) {
              author = snapshot.data;
              // Jeśli dane są dostępne, wyświetl zdjęcie użytkownika
              return BorderedUserPicture(
                radius: 34,
                pictureURI: snapshot.data!.profilePictureUrl, // Użyj URL do zdjęcia użytkownika
              );
            } else {
              // Jeśli nie ma danych, pokaż domyślną ikonę
              return Icon(Icons.account_circle);
            }
          },
        ) : BorderedUserPicture(radius: 34, pictureURI: author!.profilePictureUrl),
        SizedBox(width: 9),
        Expanded(
          child: Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: 34, maxHeight: 34),
                child: TextFormField(
                  maxLines: 1,
                  controller: _controller,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: widget.hintText,
                    hintStyle: style,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(60),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(60),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(60),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 0,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    suffixIcon: IconButton(
                      onPressed: _handleSend,
                      icon: SvgPicture.asset(
                        "assets/icons/send.svg",
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
