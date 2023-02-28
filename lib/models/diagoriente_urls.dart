import 'package:equatable/equatable.dart';

class DiagorienteUrls extends Equatable {
  final String chatBotUrl;
  final String metiersFavorisUrl;
  final String metiersRecommandesUrl;

  DiagorienteUrls({
    required this.chatBotUrl,
    required this.metiersFavorisUrl,
    required this.metiersRecommandesUrl,
  });

  factory DiagorienteUrls.fromJson(dynamic json) {
    return DiagorienteUrls(
      chatBotUrl: json['urlChatbot'] as String,
      metiersFavorisUrl: json['urlFavoris'] as String,
      metiersRecommandesUrl: json['urlRecommandes'] as String,
    );
  }

  @override
  List<Object?> get props => [chatBotUrl, metiersFavorisUrl, metiersRecommandesUrl];
}
