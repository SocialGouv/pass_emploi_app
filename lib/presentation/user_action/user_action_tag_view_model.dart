import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class UserActionTagViewModel extends Equatable {
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final bool isSelected;

  UserActionTagViewModel({
    required this.title,
    required this.backgroundColor,
    required this.textColor,
    this.isSelected = false,
  });

  @override
  List<Object?> get props => [title, backgroundColor, textColor, isSelected];
}
