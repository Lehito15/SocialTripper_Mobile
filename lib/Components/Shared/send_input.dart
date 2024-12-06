import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_tripper_mobile/Components/Shared/bordered_user_picture.dart';

import '../../Utilities/Retrievers/icon_retriever.dart';

class SendInput extends StatefulWidget {
  final Future<void> Function(String) onSend; // Callback do obsługi wysyłania tekstu
  final String hintText; // Placeholder w polu tekstowym

  const SendInput(
      {Key? key, required this.onSend, this.hintText = 'Enter text...'})
      : super(key: key);

  @override
  State<SendInput> createState() => _SendInputState();
}

class _SendInputState extends State<SendInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.length > 0) {
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
        BorderedUserPicture(
            radius: 34,
            pictureURI: "https://picsum.photos/seed/picsum/200/300"),
        SizedBox(
          width: 9,
        ),
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
                    hintText: 'Wpisz tekst...',
                    hintStyle: style,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(60),
                      // Zaokrąglone rogi
                      borderSide: BorderSide(
                        color: Colors.grey, // Kolor ramki
                        width: 0, // Grubość ramki
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
                        color: Colors.grey, // Kolor ramki po kliknięciu
                        width: 0,
                      ),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    // Wewnętrzne odstępy
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
