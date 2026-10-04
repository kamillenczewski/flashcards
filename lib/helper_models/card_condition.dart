import 'package:fproject/models/english_card.dart';

class CardCondition {
  final EnglishCard card;
  final int isSatisfied;

  static const String kCard = 'card';
  static const String kIsSatisfied = 'isSatisfied';

  CardCondition({
    required this.card,
    required this.isSatisfied,
  });

  factory CardCondition.fromMap(Map<String, dynamic> map) {
    return CardCondition(
      card: EnglishCard.fromMap(map),
      isSatisfied: map[kIsSatisfied],
    );
  }
}