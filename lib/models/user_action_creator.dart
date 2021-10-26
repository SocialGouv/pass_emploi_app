abstract class UserActionCreator {
  const UserActionCreator();
}

class JeuneActionCreator extends UserActionCreator {
  const JeuneActionCreator() : super();

  @override
  bool operator ==(Object other) => other is JeuneActionCreator;

  @override
  int get hashCode => 0;
}

class ConseillerActionCreator extends UserActionCreator {
  final String name;

  ConseillerActionCreator({required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConseillerActionCreator && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;
}
