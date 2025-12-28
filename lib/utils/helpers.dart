import 'package:diacritic/diacritic.dart';

class TextHelper {
  static String removeAccents(String text) {
    return removeDiacritics(text);
  }
}