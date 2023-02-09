import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';

class CallToAction extends Equatable {
  final String label;
  final Uri uri;
  final IconData? icon;
  final EventType eventType;

  const CallToAction(this.label, this.uri, this.eventType, {this.icon});

  @override
  List<Object?> get props => [label, uri.toString(), icon, eventType];
}
