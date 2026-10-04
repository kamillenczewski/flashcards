import 'package:fproject/models/group.dart';

class GroupAndCardsQuantity {
  final Group group;
  final int quantity;

  static const String kGroupName = 'group';
  static const String kQuantityName = 'quantity';

  GroupAndCardsQuantity({
    required this.group,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      Group.kId: group.id,
      Group.kName: group.name,
      kQuantityName: quantity,
    };
  }

  factory GroupAndCardsQuantity.fromMap(Map<String, dynamic> map) {
    return GroupAndCardsQuantity(
      group: Group(
        id: map[Group.kId], 
        name: map[Group.kName], 
      ),
      quantity: map[kQuantityName],
    );
  }
}