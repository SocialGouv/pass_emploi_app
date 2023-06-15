sealed class ChatPartageState {}

class ChatPartageNotInitializedState extends ChatPartageState {}

class ChatPartageSuccessState extends ChatPartageState {}

class ChatPartageFailureState extends ChatPartageState {}

class ChatPartageLoadingState extends ChatPartageState {}
