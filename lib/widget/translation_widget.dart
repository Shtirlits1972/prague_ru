import 'package:flutter/material.dart';
import 'package:google_cloud_translation/google_cloud_translation.dart';
import 'package:prague_ru/constants.dart';

class TranslationWidget extends StatefulWidget {
  TranslationWidget({Key? key, required this.text, required this.lang})
      : super(key: key);

  String text = '';
  String lang = 'en';

  @override
  _TranslationWidgetState createState() => _TranslationWidgetState();
}

class _TranslationWidgetState extends State<TranslationWidget> {
  String translatedText = '...'; // Начальное состояние текста
  late Translation _translation;
  bool isMounted = false; // Флаг для отслеживания состояния виджета

  @override
  void initState() {
    super.initState();
    isMounted = true; // Виджет смонтирован
    _translation = Translation(
      apiKey: translate_key,
    );
    // Вызываем функцию перевода при инициализации виджета
    translateText();
  }

  @override
  void dispose() {
    isMounted = false; // Виджет удален из дерева
    super.dispose();
  }

  // Функция для перевода текста
  void translateText() async {
    try {
      _translation.translate(text: widget.text, to: widget.lang).then((value) {
        if (isMounted) {
          setState(() {
            translatedText = value.translatedText;
          });
        }
      });
    } catch (e) {
      print(e);
      if (isMounted) {
        //  Обработка ошибок
        setState(() {
          translatedText = 'err: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(translatedText);
  }
}
