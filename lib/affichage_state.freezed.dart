// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'affichage_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Affichage {
  String get title => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AffichageCopyWith<Affichage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AffichageCopyWith<$Res> {
  factory $AffichageCopyWith(Affichage value, $Res Function(Affichage) then) =
      _$AffichageCopyWithImpl<$Res>;
  $Res call({String title, String text});
}

/// @nodoc
class _$AffichageCopyWithImpl<$Res> implements $AffichageCopyWith<$Res> {
  _$AffichageCopyWithImpl(this._value, this._then);

  final Affichage _value;
  // ignore: unused_field
  final $Res Function(Affichage) _then;

  @override
  $Res call({
    Object? title = freezed,
    Object? text = freezed,
  }) {
    return _then(_value.copyWith(
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      text: text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_AffichageCopyWith<$Res> implements $AffichageCopyWith<$Res> {
  factory _$$_AffichageCopyWith(
          _$_Affichage value, $Res Function(_$_Affichage) then) =
      __$$_AffichageCopyWithImpl<$Res>;
  @override
  $Res call({String title, String text});
}

/// @nodoc
class __$$_AffichageCopyWithImpl<$Res> extends _$AffichageCopyWithImpl<$Res>
    implements _$$_AffichageCopyWith<$Res> {
  __$$_AffichageCopyWithImpl(
      _$_Affichage _value, $Res Function(_$_Affichage) _then)
      : super(_value, (v) => _then(v as _$_Affichage));

  @override
  _$_Affichage get _value => super._value as _$_Affichage;

  @override
  $Res call({
    Object? title = freezed,
    Object? text = freezed,
  }) {
    return _then(_$_Affichage(
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      text: text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_Affichage implements _Affichage {
  const _$_Affichage({required this.title, required this.text});

  @override
  final String title;
  @override
  final String text;

  @override
  String toString() {
    return 'Affichage(title: $title, text: $text)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Affichage &&
            const DeepCollectionEquality().equals(other.title, title) &&
            const DeepCollectionEquality().equals(other.text, text));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(title),
      const DeepCollectionEquality().hash(text));

  @JsonKey(ignore: true)
  @override
  _$$_AffichageCopyWith<_$_Affichage> get copyWith =>
      __$$_AffichageCopyWithImpl<_$_Affichage>(this, _$identity);
}

abstract class _Affichage implements Affichage {
  const factory _Affichage(
      {required final String title, required final String text}) = _$_Affichage;

  @override
  String get title;
  @override
  String get text;
  @override
  @JsonKey(ignore: true)
  _$$_AffichageCopyWith<_$_Affichage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AffichageState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NotInit value) notInit,
    required TResult Function(Loading value) loading,
    required TResult Function(Content value) success,
    required TResult Function(Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(NotInit value)? notInit,
    TResult Function(Loading value)? loading,
    TResult Function(Content value)? success,
    TResult Function(Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NotInit value)? notInit,
    TResult Function(Loading value)? loading,
    TResult Function(Content value)? success,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AffichageStateCopyWith<$Res> {
  factory $AffichageStateCopyWith(
          AffichageState value, $Res Function(AffichageState) then) =
      _$AffichageStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$AffichageStateCopyWithImpl<$Res>
    implements $AffichageStateCopyWith<$Res> {
  _$AffichageStateCopyWithImpl(this._value, this._then);

  final AffichageState _value;
  // ignore: unused_field
  final $Res Function(AffichageState) _then;
}

/// @nodoc
abstract class _$$NotInitCopyWith<$Res> {
  factory _$$NotInitCopyWith(_$NotInit value, $Res Function(_$NotInit) then) =
      __$$NotInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NotInitCopyWithImpl<$Res> extends _$AffichageStateCopyWithImpl<$Res>
    implements _$$NotInitCopyWith<$Res> {
  __$$NotInitCopyWithImpl(_$NotInit _value, $Res Function(_$NotInit) _then)
      : super(_value, (v) => _then(v as _$NotInit));

  @override
  _$NotInit get _value => super._value as _$NotInit;
}

/// @nodoc

class _$NotInit implements NotInit {
  const _$NotInit();

  @override
  String toString() {
    return 'AffichageState.notInit()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$NotInit);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return notInit();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return notInit?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (notInit != null) {
      return notInit();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NotInit value) notInit,
    required TResult Function(Loading value) loading,
    required TResult Function(Content value) success,
    required TResult Function(Error value) error,
  }) {
    return notInit(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(NotInit value)? notInit,
    TResult Function(Loading value)? loading,
    TResult Function(Content value)? success,
    TResult Function(Error value)? error,
  }) {
    return notInit?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NotInit value)? notInit,
    TResult Function(Loading value)? loading,
    TResult Function(Content value)? success,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (notInit != null) {
      return notInit(this);
    }
    return orElse();
  }
}

abstract class NotInit implements AffichageState {
  const factory NotInit() = _$NotInit;
}

/// @nodoc
abstract class _$$LoadingCopyWith<$Res> {
  factory _$$LoadingCopyWith(_$Loading value, $Res Function(_$Loading) then) =
      __$$LoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingCopyWithImpl<$Res> extends _$AffichageStateCopyWithImpl<$Res>
    implements _$$LoadingCopyWith<$Res> {
  __$$LoadingCopyWithImpl(_$Loading _value, $Res Function(_$Loading) _then)
      : super(_value, (v) => _then(v as _$Loading));

  @override
  _$Loading get _value => super._value as _$Loading;
}

/// @nodoc

class _$Loading implements Loading {
  const _$Loading();

  @override
  String toString() {
    return 'AffichageState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$Loading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NotInit value) notInit,
    required TResult Function(Loading value) loading,
    required TResult Function(Content value) success,
    required TResult Function(Error value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(NotInit value)? notInit,
    TResult Function(Loading value)? loading,
    TResult Function(Content value)? success,
    TResult Function(Error value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NotInit value)? notInit,
    TResult Function(Loading value)? loading,
    TResult Function(Content value)? success,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class Loading implements AffichageState {
  const factory Loading() = _$Loading;
}

/// @nodoc
abstract class _$$ContentCopyWith<$Res> {
  factory _$$ContentCopyWith(_$Content value, $Res Function(_$Content) then) =
      __$$ContentCopyWithImpl<$Res>;
  $Res call({Affichage affichage});

  $AffichageCopyWith<$Res> get affichage;
}

/// @nodoc
class __$$ContentCopyWithImpl<$Res> extends _$AffichageStateCopyWithImpl<$Res>
    implements _$$ContentCopyWith<$Res> {
  __$$ContentCopyWithImpl(_$Content _value, $Res Function(_$Content) _then)
      : super(_value, (v) => _then(v as _$Content));

  @override
  _$Content get _value => super._value as _$Content;

  @override
  $Res call({
    Object? affichage = freezed,
  }) {
    return _then(_$Content(
      affichage == freezed
          ? _value.affichage
          : affichage // ignore: cast_nullable_to_non_nullable
              as Affichage,
    ));
  }

  @override
  $AffichageCopyWith<$Res> get affichage {
    return $AffichageCopyWith<$Res>(_value.affichage, (value) {
      return _then(_value.copyWith(affichage: value));
    });
  }
}

/// @nodoc

class _$Content implements Content {
  const _$Content(this.affichage);

  @override
  final Affichage affichage;

  @override
  String toString() {
    return 'AffichageState.success(affichage: $affichage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Content &&
            const DeepCollectionEquality().equals(other.affichage, affichage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(affichage));

  @JsonKey(ignore: true)
  @override
  _$$ContentCopyWith<_$Content> get copyWith =>
      __$$ContentCopyWithImpl<_$Content>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return success(affichage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return success?.call(affichage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(affichage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NotInit value) notInit,
    required TResult Function(Loading value) loading,
    required TResult Function(Content value) success,
    required TResult Function(Error value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(NotInit value)? notInit,
    TResult Function(Loading value)? loading,
    TResult Function(Content value)? success,
    TResult Function(Error value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NotInit value)? notInit,
    TResult Function(Loading value)? loading,
    TResult Function(Content value)? success,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class Content implements AffichageState {
  const factory Content(final Affichage affichage) = _$Content;

  Affichage get affichage;
  @JsonKey(ignore: true)
  _$$ContentCopyWith<_$Content> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorCopyWith<$Res> {
  factory _$$ErrorCopyWith(_$Error value, $Res Function(_$Error) then) =
      __$$ErrorCopyWithImpl<$Res>;
  $Res call({String message});
}

/// @nodoc
class __$$ErrorCopyWithImpl<$Res> extends _$AffichageStateCopyWithImpl<$Res>
    implements _$$ErrorCopyWith<$Res> {
  __$$ErrorCopyWithImpl(_$Error _value, $Res Function(_$Error) _then)
      : super(_value, (v) => _then(v as _$Error));

  @override
  _$Error get _value => super._value as _$Error;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$Error(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$Error implements Error {
  const _$Error(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'AffichageState.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Error &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$$ErrorCopyWith<_$Error> get copyWith =>
      __$$ErrorCopyWithImpl<_$Error>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NotInit value) notInit,
    required TResult Function(Loading value) loading,
    required TResult Function(Content value) success,
    required TResult Function(Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(NotInit value)? notInit,
    TResult Function(Loading value)? loading,
    TResult Function(Content value)? success,
    TResult Function(Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NotInit value)? notInit,
    TResult Function(Loading value)? loading,
    TResult Function(Content value)? success,
    TResult Function(Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class Error implements AffichageState {
  const factory Error(final String message) = _$Error;

  String get message;
  @JsonKey(ignore: true)
  _$$ErrorCopyWith<_$Error> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Un {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LeUnNotInit value) notInit,
    required TResult Function(LeUnLoading value) loading,
    required TResult Function(LeUnContent value) success,
    required TResult Function(LeUnError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(LeUnNotInit value)? notInit,
    TResult Function(LeUnLoading value)? loading,
    TResult Function(LeUnContent value)? success,
    TResult Function(LeUnError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LeUnNotInit value)? notInit,
    TResult Function(LeUnLoading value)? loading,
    TResult Function(LeUnContent value)? success,
    TResult Function(LeUnError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnCopyWith<$Res> {
  factory $UnCopyWith(Un value, $Res Function(Un) then) =
      _$UnCopyWithImpl<$Res>;
}

/// @nodoc
class _$UnCopyWithImpl<$Res> implements $UnCopyWith<$Res> {
  _$UnCopyWithImpl(this._value, this._then);

  final Un _value;
  // ignore: unused_field
  final $Res Function(Un) _then;
}

/// @nodoc
abstract class _$$LeUnNotInitCopyWith<$Res> {
  factory _$$LeUnNotInitCopyWith(
          _$LeUnNotInit value, $Res Function(_$LeUnNotInit) then) =
      __$$LeUnNotInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LeUnNotInitCopyWithImpl<$Res> extends _$UnCopyWithImpl<$Res>
    implements _$$LeUnNotInitCopyWith<$Res> {
  __$$LeUnNotInitCopyWithImpl(
      _$LeUnNotInit _value, $Res Function(_$LeUnNotInit) _then)
      : super(_value, (v) => _then(v as _$LeUnNotInit));

  @override
  _$LeUnNotInit get _value => super._value as _$LeUnNotInit;
}

/// @nodoc

class _$LeUnNotInit implements LeUnNotInit {
  const _$LeUnNotInit();

  @override
  String toString() {
    return 'Un.notInit()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LeUnNotInit);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return notInit();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return notInit?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (notInit != null) {
      return notInit();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LeUnNotInit value) notInit,
    required TResult Function(LeUnLoading value) loading,
    required TResult Function(LeUnContent value) success,
    required TResult Function(LeUnError value) error,
  }) {
    return notInit(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(LeUnNotInit value)? notInit,
    TResult Function(LeUnLoading value)? loading,
    TResult Function(LeUnContent value)? success,
    TResult Function(LeUnError value)? error,
  }) {
    return notInit?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LeUnNotInit value)? notInit,
    TResult Function(LeUnLoading value)? loading,
    TResult Function(LeUnContent value)? success,
    TResult Function(LeUnError value)? error,
    required TResult orElse(),
  }) {
    if (notInit != null) {
      return notInit(this);
    }
    return orElse();
  }
}

abstract class LeUnNotInit implements Un {
  const factory LeUnNotInit() = _$LeUnNotInit;
}

/// @nodoc
abstract class _$$LeUnLoadingCopyWith<$Res> {
  factory _$$LeUnLoadingCopyWith(
          _$LeUnLoading value, $Res Function(_$LeUnLoading) then) =
      __$$LeUnLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LeUnLoadingCopyWithImpl<$Res> extends _$UnCopyWithImpl<$Res>
    implements _$$LeUnLoadingCopyWith<$Res> {
  __$$LeUnLoadingCopyWithImpl(
      _$LeUnLoading _value, $Res Function(_$LeUnLoading) _then)
      : super(_value, (v) => _then(v as _$LeUnLoading));

  @override
  _$LeUnLoading get _value => super._value as _$LeUnLoading;
}

/// @nodoc

class _$LeUnLoading implements LeUnLoading {
  const _$LeUnLoading();

  @override
  String toString() {
    return 'Un.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LeUnLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LeUnNotInit value) notInit,
    required TResult Function(LeUnLoading value) loading,
    required TResult Function(LeUnContent value) success,
    required TResult Function(LeUnError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(LeUnNotInit value)? notInit,
    TResult Function(LeUnLoading value)? loading,
    TResult Function(LeUnContent value)? success,
    TResult Function(LeUnError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LeUnNotInit value)? notInit,
    TResult Function(LeUnLoading value)? loading,
    TResult Function(LeUnContent value)? success,
    TResult Function(LeUnError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class LeUnLoading implements Un {
  const factory LeUnLoading() = _$LeUnLoading;
}

/// @nodoc
abstract class _$$LeUnContentCopyWith<$Res> {
  factory _$$LeUnContentCopyWith(
          _$LeUnContent value, $Res Function(_$LeUnContent) then) =
      __$$LeUnContentCopyWithImpl<$Res>;
  $Res call({Affichage affichage});

  $AffichageCopyWith<$Res> get affichage;
}

/// @nodoc
class __$$LeUnContentCopyWithImpl<$Res> extends _$UnCopyWithImpl<$Res>
    implements _$$LeUnContentCopyWith<$Res> {
  __$$LeUnContentCopyWithImpl(
      _$LeUnContent _value, $Res Function(_$LeUnContent) _then)
      : super(_value, (v) => _then(v as _$LeUnContent));

  @override
  _$LeUnContent get _value => super._value as _$LeUnContent;

  @override
  $Res call({
    Object? affichage = freezed,
  }) {
    return _then(_$LeUnContent(
      affichage == freezed
          ? _value.affichage
          : affichage // ignore: cast_nullable_to_non_nullable
              as Affichage,
    ));
  }

  @override
  $AffichageCopyWith<$Res> get affichage {
    return $AffichageCopyWith<$Res>(_value.affichage, (value) {
      return _then(_value.copyWith(affichage: value));
    });
  }
}

/// @nodoc

class _$LeUnContent implements LeUnContent {
  const _$LeUnContent(this.affichage);

  @override
  final Affichage affichage;

  @override
  String toString() {
    return 'Un.success(affichage: $affichage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeUnContent &&
            const DeepCollectionEquality().equals(other.affichage, affichage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(affichage));

  @JsonKey(ignore: true)
  @override
  _$$LeUnContentCopyWith<_$LeUnContent> get copyWith =>
      __$$LeUnContentCopyWithImpl<_$LeUnContent>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return success(affichage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return success?.call(affichage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(affichage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LeUnNotInit value) notInit,
    required TResult Function(LeUnLoading value) loading,
    required TResult Function(LeUnContent value) success,
    required TResult Function(LeUnError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(LeUnNotInit value)? notInit,
    TResult Function(LeUnLoading value)? loading,
    TResult Function(LeUnContent value)? success,
    TResult Function(LeUnError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LeUnNotInit value)? notInit,
    TResult Function(LeUnLoading value)? loading,
    TResult Function(LeUnContent value)? success,
    TResult Function(LeUnError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class LeUnContent implements Un {
  const factory LeUnContent(final Affichage affichage) = _$LeUnContent;

  Affichage get affichage;
  @JsonKey(ignore: true)
  _$$LeUnContentCopyWith<_$LeUnContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LeUnErrorCopyWith<$Res> {
  factory _$$LeUnErrorCopyWith(
          _$LeUnError value, $Res Function(_$LeUnError) then) =
      __$$LeUnErrorCopyWithImpl<$Res>;
  $Res call({String message});
}

/// @nodoc
class __$$LeUnErrorCopyWithImpl<$Res> extends _$UnCopyWithImpl<$Res>
    implements _$$LeUnErrorCopyWith<$Res> {
  __$$LeUnErrorCopyWithImpl(
      _$LeUnError _value, $Res Function(_$LeUnError) _then)
      : super(_value, (v) => _then(v as _$LeUnError));

  @override
  _$LeUnError get _value => super._value as _$LeUnError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$LeUnError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$LeUnError implements LeUnError {
  const _$LeUnError(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Un.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LeUnError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$$LeUnErrorCopyWith<_$LeUnError> get copyWith =>
      __$$LeUnErrorCopyWithImpl<_$LeUnError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LeUnNotInit value) notInit,
    required TResult Function(LeUnLoading value) loading,
    required TResult Function(LeUnContent value) success,
    required TResult Function(LeUnError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(LeUnNotInit value)? notInit,
    TResult Function(LeUnLoading value)? loading,
    TResult Function(LeUnContent value)? success,
    TResult Function(LeUnError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LeUnNotInit value)? notInit,
    TResult Function(LeUnLoading value)? loading,
    TResult Function(LeUnContent value)? success,
    TResult Function(LeUnError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class LeUnError implements Un {
  const factory LeUnError(final String message) = _$LeUnError;

  String get message;
  @JsonKey(ignore: true)
  _$$LeUnErrorCopyWith<_$LeUnError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Deux {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeuxNotInit value) notInit,
    required TResult Function(DeuxLoading value) loading,
    required TResult Function(DeuxContent value) success,
    required TResult Function(DeuxError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DeuxNotInit value)? notInit,
    TResult Function(DeuxLoading value)? loading,
    TResult Function(DeuxContent value)? success,
    TResult Function(DeuxError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeuxNotInit value)? notInit,
    TResult Function(DeuxLoading value)? loading,
    TResult Function(DeuxContent value)? success,
    TResult Function(DeuxError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeuxCopyWith<$Res> {
  factory $DeuxCopyWith(Deux value, $Res Function(Deux) then) =
      _$DeuxCopyWithImpl<$Res>;
}

/// @nodoc
class _$DeuxCopyWithImpl<$Res> implements $DeuxCopyWith<$Res> {
  _$DeuxCopyWithImpl(this._value, this._then);

  final Deux _value;
  // ignore: unused_field
  final $Res Function(Deux) _then;
}

/// @nodoc
abstract class _$$DeuxNotInitCopyWith<$Res> {
  factory _$$DeuxNotInitCopyWith(
          _$DeuxNotInit value, $Res Function(_$DeuxNotInit) then) =
      __$$DeuxNotInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DeuxNotInitCopyWithImpl<$Res> extends _$DeuxCopyWithImpl<$Res>
    implements _$$DeuxNotInitCopyWith<$Res> {
  __$$DeuxNotInitCopyWithImpl(
      _$DeuxNotInit _value, $Res Function(_$DeuxNotInit) _then)
      : super(_value, (v) => _then(v as _$DeuxNotInit));

  @override
  _$DeuxNotInit get _value => super._value as _$DeuxNotInit;
}

/// @nodoc

class _$DeuxNotInit implements DeuxNotInit {
  const _$DeuxNotInit();

  @override
  String toString() {
    return 'Deux.notInit()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DeuxNotInit);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return notInit();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return notInit?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (notInit != null) {
      return notInit();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeuxNotInit value) notInit,
    required TResult Function(DeuxLoading value) loading,
    required TResult Function(DeuxContent value) success,
    required TResult Function(DeuxError value) error,
  }) {
    return notInit(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DeuxNotInit value)? notInit,
    TResult Function(DeuxLoading value)? loading,
    TResult Function(DeuxContent value)? success,
    TResult Function(DeuxError value)? error,
  }) {
    return notInit?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeuxNotInit value)? notInit,
    TResult Function(DeuxLoading value)? loading,
    TResult Function(DeuxContent value)? success,
    TResult Function(DeuxError value)? error,
    required TResult orElse(),
  }) {
    if (notInit != null) {
      return notInit(this);
    }
    return orElse();
  }
}

abstract class DeuxNotInit implements Deux {
  const factory DeuxNotInit() = _$DeuxNotInit;
}

/// @nodoc
abstract class _$$DeuxLoadingCopyWith<$Res> {
  factory _$$DeuxLoadingCopyWith(
          _$DeuxLoading value, $Res Function(_$DeuxLoading) then) =
      __$$DeuxLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DeuxLoadingCopyWithImpl<$Res> extends _$DeuxCopyWithImpl<$Res>
    implements _$$DeuxLoadingCopyWith<$Res> {
  __$$DeuxLoadingCopyWithImpl(
      _$DeuxLoading _value, $Res Function(_$DeuxLoading) _then)
      : super(_value, (v) => _then(v as _$DeuxLoading));

  @override
  _$DeuxLoading get _value => super._value as _$DeuxLoading;
}

/// @nodoc

class _$DeuxLoading implements DeuxLoading {
  const _$DeuxLoading();

  @override
  String toString() {
    return 'Deux.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DeuxLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeuxNotInit value) notInit,
    required TResult Function(DeuxLoading value) loading,
    required TResult Function(DeuxContent value) success,
    required TResult Function(DeuxError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DeuxNotInit value)? notInit,
    TResult Function(DeuxLoading value)? loading,
    TResult Function(DeuxContent value)? success,
    TResult Function(DeuxError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeuxNotInit value)? notInit,
    TResult Function(DeuxLoading value)? loading,
    TResult Function(DeuxContent value)? success,
    TResult Function(DeuxError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class DeuxLoading implements Deux {
  const factory DeuxLoading() = _$DeuxLoading;
}

/// @nodoc
abstract class _$$DeuxContentCopyWith<$Res> {
  factory _$$DeuxContentCopyWith(
          _$DeuxContent value, $Res Function(_$DeuxContent) then) =
      __$$DeuxContentCopyWithImpl<$Res>;
  $Res call({Affichage affichage});

  $AffichageCopyWith<$Res> get affichage;
}

/// @nodoc
class __$$DeuxContentCopyWithImpl<$Res> extends _$DeuxCopyWithImpl<$Res>
    implements _$$DeuxContentCopyWith<$Res> {
  __$$DeuxContentCopyWithImpl(
      _$DeuxContent _value, $Res Function(_$DeuxContent) _then)
      : super(_value, (v) => _then(v as _$DeuxContent));

  @override
  _$DeuxContent get _value => super._value as _$DeuxContent;

  @override
  $Res call({
    Object? affichage = freezed,
  }) {
    return _then(_$DeuxContent(
      affichage == freezed
          ? _value.affichage
          : affichage // ignore: cast_nullable_to_non_nullable
              as Affichage,
    ));
  }

  @override
  $AffichageCopyWith<$Res> get affichage {
    return $AffichageCopyWith<$Res>(_value.affichage, (value) {
      return _then(_value.copyWith(affichage: value));
    });
  }
}

/// @nodoc

class _$DeuxContent implements DeuxContent {
  const _$DeuxContent(this.affichage);

  @override
  final Affichage affichage;

  @override
  String toString() {
    return 'Deux.success(affichage: $affichage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeuxContent &&
            const DeepCollectionEquality().equals(other.affichage, affichage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(affichage));

  @JsonKey(ignore: true)
  @override
  _$$DeuxContentCopyWith<_$DeuxContent> get copyWith =>
      __$$DeuxContentCopyWithImpl<_$DeuxContent>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return success(affichage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return success?.call(affichage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(affichage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeuxNotInit value) notInit,
    required TResult Function(DeuxLoading value) loading,
    required TResult Function(DeuxContent value) success,
    required TResult Function(DeuxError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DeuxNotInit value)? notInit,
    TResult Function(DeuxLoading value)? loading,
    TResult Function(DeuxContent value)? success,
    TResult Function(DeuxError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeuxNotInit value)? notInit,
    TResult Function(DeuxLoading value)? loading,
    TResult Function(DeuxContent value)? success,
    TResult Function(DeuxError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class DeuxContent implements Deux {
  const factory DeuxContent(final Affichage affichage) = _$DeuxContent;

  Affichage get affichage;
  @JsonKey(ignore: true)
  _$$DeuxContentCopyWith<_$DeuxContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DeuxErrorCopyWith<$Res> {
  factory _$$DeuxErrorCopyWith(
          _$DeuxError value, $Res Function(_$DeuxError) then) =
      __$$DeuxErrorCopyWithImpl<$Res>;
  $Res call({String message});
}

/// @nodoc
class __$$DeuxErrorCopyWithImpl<$Res> extends _$DeuxCopyWithImpl<$Res>
    implements _$$DeuxErrorCopyWith<$Res> {
  __$$DeuxErrorCopyWithImpl(
      _$DeuxError _value, $Res Function(_$DeuxError) _then)
      : super(_value, (v) => _then(v as _$DeuxError));

  @override
  _$DeuxError get _value => super._value as _$DeuxError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$DeuxError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DeuxError implements DeuxError {
  const _$DeuxError(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Deux.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeuxError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$$DeuxErrorCopyWith<_$DeuxError> get copyWith =>
      __$$DeuxErrorCopyWithImpl<_$DeuxError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DeuxNotInit value) notInit,
    required TResult Function(DeuxLoading value) loading,
    required TResult Function(DeuxContent value) success,
    required TResult Function(DeuxError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DeuxNotInit value)? notInit,
    TResult Function(DeuxLoading value)? loading,
    TResult Function(DeuxContent value)? success,
    TResult Function(DeuxError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DeuxNotInit value)? notInit,
    TResult Function(DeuxLoading value)? loading,
    TResult Function(DeuxContent value)? success,
    TResult Function(DeuxError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class DeuxError implements Deux {
  const factory DeuxError(final String message) = _$DeuxError;

  String get message;
  @JsonKey(ignore: true)
  _$$DeuxErrorCopyWith<_$DeuxError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Trois {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TroisNotInit value) notInit,
    required TResult Function(TroisLoading value) loading,
    required TResult Function(TroisContent value) success,
    required TResult Function(TroisError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(TroisNotInit value)? notInit,
    TResult Function(TroisLoading value)? loading,
    TResult Function(TroisContent value)? success,
    TResult Function(TroisError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TroisNotInit value)? notInit,
    TResult Function(TroisLoading value)? loading,
    TResult Function(TroisContent value)? success,
    TResult Function(TroisError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TroisCopyWith<$Res> {
  factory $TroisCopyWith(Trois value, $Res Function(Trois) then) =
      _$TroisCopyWithImpl<$Res>;
}

/// @nodoc
class _$TroisCopyWithImpl<$Res> implements $TroisCopyWith<$Res> {
  _$TroisCopyWithImpl(this._value, this._then);

  final Trois _value;
  // ignore: unused_field
  final $Res Function(Trois) _then;
}

/// @nodoc
abstract class _$$TroisNotInitCopyWith<$Res> {
  factory _$$TroisNotInitCopyWith(
          _$TroisNotInit value, $Res Function(_$TroisNotInit) then) =
      __$$TroisNotInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TroisNotInitCopyWithImpl<$Res> extends _$TroisCopyWithImpl<$Res>
    implements _$$TroisNotInitCopyWith<$Res> {
  __$$TroisNotInitCopyWithImpl(
      _$TroisNotInit _value, $Res Function(_$TroisNotInit) _then)
      : super(_value, (v) => _then(v as _$TroisNotInit));

  @override
  _$TroisNotInit get _value => super._value as _$TroisNotInit;
}

/// @nodoc

class _$TroisNotInit implements TroisNotInit {
  const _$TroisNotInit();

  @override
  String toString() {
    return 'Trois.notInit()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$TroisNotInit);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return notInit();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return notInit?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (notInit != null) {
      return notInit();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TroisNotInit value) notInit,
    required TResult Function(TroisLoading value) loading,
    required TResult Function(TroisContent value) success,
    required TResult Function(TroisError value) error,
  }) {
    return notInit(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(TroisNotInit value)? notInit,
    TResult Function(TroisLoading value)? loading,
    TResult Function(TroisContent value)? success,
    TResult Function(TroisError value)? error,
  }) {
    return notInit?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TroisNotInit value)? notInit,
    TResult Function(TroisLoading value)? loading,
    TResult Function(TroisContent value)? success,
    TResult Function(TroisError value)? error,
    required TResult orElse(),
  }) {
    if (notInit != null) {
      return notInit(this);
    }
    return orElse();
  }
}

abstract class TroisNotInit implements Trois {
  const factory TroisNotInit() = _$TroisNotInit;
}

/// @nodoc
abstract class _$$TroisLoadingCopyWith<$Res> {
  factory _$$TroisLoadingCopyWith(
          _$TroisLoading value, $Res Function(_$TroisLoading) then) =
      __$$TroisLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TroisLoadingCopyWithImpl<$Res> extends _$TroisCopyWithImpl<$Res>
    implements _$$TroisLoadingCopyWith<$Res> {
  __$$TroisLoadingCopyWithImpl(
      _$TroisLoading _value, $Res Function(_$TroisLoading) _then)
      : super(_value, (v) => _then(v as _$TroisLoading));

  @override
  _$TroisLoading get _value => super._value as _$TroisLoading;
}

/// @nodoc

class _$TroisLoading implements TroisLoading {
  const _$TroisLoading();

  @override
  String toString() {
    return 'Trois.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$TroisLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TroisNotInit value) notInit,
    required TResult Function(TroisLoading value) loading,
    required TResult Function(TroisContent value) success,
    required TResult Function(TroisError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(TroisNotInit value)? notInit,
    TResult Function(TroisLoading value)? loading,
    TResult Function(TroisContent value)? success,
    TResult Function(TroisError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TroisNotInit value)? notInit,
    TResult Function(TroisLoading value)? loading,
    TResult Function(TroisContent value)? success,
    TResult Function(TroisError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class TroisLoading implements Trois {
  const factory TroisLoading() = _$TroisLoading;
}

/// @nodoc
abstract class _$$TroisContentCopyWith<$Res> {
  factory _$$TroisContentCopyWith(
          _$TroisContent value, $Res Function(_$TroisContent) then) =
      __$$TroisContentCopyWithImpl<$Res>;
  $Res call({Affichage affichage});

  $AffichageCopyWith<$Res> get affichage;
}

/// @nodoc
class __$$TroisContentCopyWithImpl<$Res> extends _$TroisCopyWithImpl<$Res>
    implements _$$TroisContentCopyWith<$Res> {
  __$$TroisContentCopyWithImpl(
      _$TroisContent _value, $Res Function(_$TroisContent) _then)
      : super(_value, (v) => _then(v as _$TroisContent));

  @override
  _$TroisContent get _value => super._value as _$TroisContent;

  @override
  $Res call({
    Object? affichage = freezed,
  }) {
    return _then(_$TroisContent(
      affichage == freezed
          ? _value.affichage
          : affichage // ignore: cast_nullable_to_non_nullable
              as Affichage,
    ));
  }

  @override
  $AffichageCopyWith<$Res> get affichage {
    return $AffichageCopyWith<$Res>(_value.affichage, (value) {
      return _then(_value.copyWith(affichage: value));
    });
  }
}

/// @nodoc

class _$TroisContent implements TroisContent {
  const _$TroisContent(this.affichage);

  @override
  final Affichage affichage;

  @override
  String toString() {
    return 'Trois.success(affichage: $affichage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TroisContent &&
            const DeepCollectionEquality().equals(other.affichage, affichage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(affichage));

  @JsonKey(ignore: true)
  @override
  _$$TroisContentCopyWith<_$TroisContent> get copyWith =>
      __$$TroisContentCopyWithImpl<_$TroisContent>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return success(affichage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return success?.call(affichage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(affichage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TroisNotInit value) notInit,
    required TResult Function(TroisLoading value) loading,
    required TResult Function(TroisContent value) success,
    required TResult Function(TroisError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(TroisNotInit value)? notInit,
    TResult Function(TroisLoading value)? loading,
    TResult Function(TroisContent value)? success,
    TResult Function(TroisError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TroisNotInit value)? notInit,
    TResult Function(TroisLoading value)? loading,
    TResult Function(TroisContent value)? success,
    TResult Function(TroisError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class TroisContent implements Trois {
  const factory TroisContent(final Affichage affichage) = _$TroisContent;

  Affichage get affichage;
  @JsonKey(ignore: true)
  _$$TroisContentCopyWith<_$TroisContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TroisErrorCopyWith<$Res> {
  factory _$$TroisErrorCopyWith(
          _$TroisError value, $Res Function(_$TroisError) then) =
      __$$TroisErrorCopyWithImpl<$Res>;
  $Res call({String message});
}

/// @nodoc
class __$$TroisErrorCopyWithImpl<$Res> extends _$TroisCopyWithImpl<$Res>
    implements _$$TroisErrorCopyWith<$Res> {
  __$$TroisErrorCopyWithImpl(
      _$TroisError _value, $Res Function(_$TroisError) _then)
      : super(_value, (v) => _then(v as _$TroisError));

  @override
  _$TroisError get _value => super._value as _$TroisError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$TroisError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$TroisError implements TroisError {
  const _$TroisError(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Trois.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TroisError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$$TroisErrorCopyWith<_$TroisError> get copyWith =>
      __$$TroisErrorCopyWithImpl<_$TroisError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TroisNotInit value) notInit,
    required TResult Function(TroisLoading value) loading,
    required TResult Function(TroisContent value) success,
    required TResult Function(TroisError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(TroisNotInit value)? notInit,
    TResult Function(TroisLoading value)? loading,
    TResult Function(TroisContent value)? success,
    TResult Function(TroisError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TroisNotInit value)? notInit,
    TResult Function(TroisLoading value)? loading,
    TResult Function(TroisContent value)? success,
    TResult Function(TroisError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class TroisError implements Trois {
  const factory TroisError(final String message) = _$TroisError;

  String get message;
  @JsonKey(ignore: true)
  _$$TroisErrorCopyWith<_$TroisError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Quatre {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(QuatreNotInit value) notInit,
    required TResult Function(QuatreLoading value) loading,
    required TResult Function(QuatreContent value) success,
    required TResult Function(QuatreError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(QuatreNotInit value)? notInit,
    TResult Function(QuatreLoading value)? loading,
    TResult Function(QuatreContent value)? success,
    TResult Function(QuatreError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(QuatreNotInit value)? notInit,
    TResult Function(QuatreLoading value)? loading,
    TResult Function(QuatreContent value)? success,
    TResult Function(QuatreError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuatreCopyWith<$Res> {
  factory $QuatreCopyWith(Quatre value, $Res Function(Quatre) then) =
      _$QuatreCopyWithImpl<$Res>;
}

/// @nodoc
class _$QuatreCopyWithImpl<$Res> implements $QuatreCopyWith<$Res> {
  _$QuatreCopyWithImpl(this._value, this._then);

  final Quatre _value;
  // ignore: unused_field
  final $Res Function(Quatre) _then;
}

/// @nodoc
abstract class _$$QuatreNotInitCopyWith<$Res> {
  factory _$$QuatreNotInitCopyWith(
          _$QuatreNotInit value, $Res Function(_$QuatreNotInit) then) =
      __$$QuatreNotInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$$QuatreNotInitCopyWithImpl<$Res> extends _$QuatreCopyWithImpl<$Res>
    implements _$$QuatreNotInitCopyWith<$Res> {
  __$$QuatreNotInitCopyWithImpl(
      _$QuatreNotInit _value, $Res Function(_$QuatreNotInit) _then)
      : super(_value, (v) => _then(v as _$QuatreNotInit));

  @override
  _$QuatreNotInit get _value => super._value as _$QuatreNotInit;
}

/// @nodoc

class _$QuatreNotInit implements QuatreNotInit {
  const _$QuatreNotInit();

  @override
  String toString() {
    return 'Quatre.notInit()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$QuatreNotInit);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return notInit();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return notInit?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (notInit != null) {
      return notInit();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(QuatreNotInit value) notInit,
    required TResult Function(QuatreLoading value) loading,
    required TResult Function(QuatreContent value) success,
    required TResult Function(QuatreError value) error,
  }) {
    return notInit(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(QuatreNotInit value)? notInit,
    TResult Function(QuatreLoading value)? loading,
    TResult Function(QuatreContent value)? success,
    TResult Function(QuatreError value)? error,
  }) {
    return notInit?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(QuatreNotInit value)? notInit,
    TResult Function(QuatreLoading value)? loading,
    TResult Function(QuatreContent value)? success,
    TResult Function(QuatreError value)? error,
    required TResult orElse(),
  }) {
    if (notInit != null) {
      return notInit(this);
    }
    return orElse();
  }
}

abstract class QuatreNotInit implements Quatre {
  const factory QuatreNotInit() = _$QuatreNotInit;
}

/// @nodoc
abstract class _$$QuatreLoadingCopyWith<$Res> {
  factory _$$QuatreLoadingCopyWith(
          _$QuatreLoading value, $Res Function(_$QuatreLoading) then) =
      __$$QuatreLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$$QuatreLoadingCopyWithImpl<$Res> extends _$QuatreCopyWithImpl<$Res>
    implements _$$QuatreLoadingCopyWith<$Res> {
  __$$QuatreLoadingCopyWithImpl(
      _$QuatreLoading _value, $Res Function(_$QuatreLoading) _then)
      : super(_value, (v) => _then(v as _$QuatreLoading));

  @override
  _$QuatreLoading get _value => super._value as _$QuatreLoading;
}

/// @nodoc

class _$QuatreLoading implements QuatreLoading {
  const _$QuatreLoading();

  @override
  String toString() {
    return 'Quatre.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$QuatreLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(QuatreNotInit value) notInit,
    required TResult Function(QuatreLoading value) loading,
    required TResult Function(QuatreContent value) success,
    required TResult Function(QuatreError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(QuatreNotInit value)? notInit,
    TResult Function(QuatreLoading value)? loading,
    TResult Function(QuatreContent value)? success,
    TResult Function(QuatreError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(QuatreNotInit value)? notInit,
    TResult Function(QuatreLoading value)? loading,
    TResult Function(QuatreContent value)? success,
    TResult Function(QuatreError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class QuatreLoading implements Quatre {
  const factory QuatreLoading() = _$QuatreLoading;
}

/// @nodoc
abstract class _$$QuatreContentCopyWith<$Res> {
  factory _$$QuatreContentCopyWith(
          _$QuatreContent value, $Res Function(_$QuatreContent) then) =
      __$$QuatreContentCopyWithImpl<$Res>;
  $Res call({Affichage affichage});

  $AffichageCopyWith<$Res> get affichage;
}

/// @nodoc
class __$$QuatreContentCopyWithImpl<$Res> extends _$QuatreCopyWithImpl<$Res>
    implements _$$QuatreContentCopyWith<$Res> {
  __$$QuatreContentCopyWithImpl(
      _$QuatreContent _value, $Res Function(_$QuatreContent) _then)
      : super(_value, (v) => _then(v as _$QuatreContent));

  @override
  _$QuatreContent get _value => super._value as _$QuatreContent;

  @override
  $Res call({
    Object? affichage = freezed,
  }) {
    return _then(_$QuatreContent(
      affichage == freezed
          ? _value.affichage
          : affichage // ignore: cast_nullable_to_non_nullable
              as Affichage,
    ));
  }

  @override
  $AffichageCopyWith<$Res> get affichage {
    return $AffichageCopyWith<$Res>(_value.affichage, (value) {
      return _then(_value.copyWith(affichage: value));
    });
  }
}

/// @nodoc

class _$QuatreContent implements QuatreContent {
  const _$QuatreContent(this.affichage);

  @override
  final Affichage affichage;

  @override
  String toString() {
    return 'Quatre.success(affichage: $affichage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuatreContent &&
            const DeepCollectionEquality().equals(other.affichage, affichage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(affichage));

  @JsonKey(ignore: true)
  @override
  _$$QuatreContentCopyWith<_$QuatreContent> get copyWith =>
      __$$QuatreContentCopyWithImpl<_$QuatreContent>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return success(affichage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return success?.call(affichage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(affichage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(QuatreNotInit value) notInit,
    required TResult Function(QuatreLoading value) loading,
    required TResult Function(QuatreContent value) success,
    required TResult Function(QuatreError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(QuatreNotInit value)? notInit,
    TResult Function(QuatreLoading value)? loading,
    TResult Function(QuatreContent value)? success,
    TResult Function(QuatreError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(QuatreNotInit value)? notInit,
    TResult Function(QuatreLoading value)? loading,
    TResult Function(QuatreContent value)? success,
    TResult Function(QuatreError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class QuatreContent implements Quatre {
  const factory QuatreContent(final Affichage affichage) = _$QuatreContent;

  Affichage get affichage;
  @JsonKey(ignore: true)
  _$$QuatreContentCopyWith<_$QuatreContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$QuatreErrorCopyWith<$Res> {
  factory _$$QuatreErrorCopyWith(
          _$QuatreError value, $Res Function(_$QuatreError) then) =
      __$$QuatreErrorCopyWithImpl<$Res>;
  $Res call({String message});
}

/// @nodoc
class __$$QuatreErrorCopyWithImpl<$Res> extends _$QuatreCopyWithImpl<$Res>
    implements _$$QuatreErrorCopyWith<$Res> {
  __$$QuatreErrorCopyWithImpl(
      _$QuatreError _value, $Res Function(_$QuatreError) _then)
      : super(_value, (v) => _then(v as _$QuatreError));

  @override
  _$QuatreError get _value => super._value as _$QuatreError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$QuatreError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$QuatreError implements QuatreError {
  const _$QuatreError(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Quatre.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuatreError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$$QuatreErrorCopyWith<_$QuatreError> get copyWith =>
      __$$QuatreErrorCopyWithImpl<_$QuatreError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(QuatreNotInit value) notInit,
    required TResult Function(QuatreLoading value) loading,
    required TResult Function(QuatreContent value) success,
    required TResult Function(QuatreError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(QuatreNotInit value)? notInit,
    TResult Function(QuatreLoading value)? loading,
    TResult Function(QuatreContent value)? success,
    TResult Function(QuatreError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(QuatreNotInit value)? notInit,
    TResult Function(QuatreLoading value)? loading,
    TResult Function(QuatreContent value)? success,
    TResult Function(QuatreError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class QuatreError implements Quatre {
  const factory QuatreError(final String message) = _$QuatreError;

  String get message;
  @JsonKey(ignore: true)
  _$$QuatreErrorCopyWith<_$QuatreError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Cinq {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CinqNotInit value) notInit,
    required TResult Function(CinqLoading value) loading,
    required TResult Function(CinqContent value) success,
    required TResult Function(CinqError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(CinqNotInit value)? notInit,
    TResult Function(CinqLoading value)? loading,
    TResult Function(CinqContent value)? success,
    TResult Function(CinqError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CinqNotInit value)? notInit,
    TResult Function(CinqLoading value)? loading,
    TResult Function(CinqContent value)? success,
    TResult Function(CinqError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CinqCopyWith<$Res> {
  factory $CinqCopyWith(Cinq value, $Res Function(Cinq) then) =
      _$CinqCopyWithImpl<$Res>;
}

/// @nodoc
class _$CinqCopyWithImpl<$Res> implements $CinqCopyWith<$Res> {
  _$CinqCopyWithImpl(this._value, this._then);

  final Cinq _value;
  // ignore: unused_field
  final $Res Function(Cinq) _then;
}

/// @nodoc
abstract class _$$CinqNotInitCopyWith<$Res> {
  factory _$$CinqNotInitCopyWith(
          _$CinqNotInit value, $Res Function(_$CinqNotInit) then) =
      __$$CinqNotInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CinqNotInitCopyWithImpl<$Res> extends _$CinqCopyWithImpl<$Res>
    implements _$$CinqNotInitCopyWith<$Res> {
  __$$CinqNotInitCopyWithImpl(
      _$CinqNotInit _value, $Res Function(_$CinqNotInit) _then)
      : super(_value, (v) => _then(v as _$CinqNotInit));

  @override
  _$CinqNotInit get _value => super._value as _$CinqNotInit;
}

/// @nodoc

class _$CinqNotInit implements CinqNotInit {
  const _$CinqNotInit();

  @override
  String toString() {
    return 'Cinq.notInit()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CinqNotInit);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return notInit();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return notInit?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (notInit != null) {
      return notInit();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CinqNotInit value) notInit,
    required TResult Function(CinqLoading value) loading,
    required TResult Function(CinqContent value) success,
    required TResult Function(CinqError value) error,
  }) {
    return notInit(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(CinqNotInit value)? notInit,
    TResult Function(CinqLoading value)? loading,
    TResult Function(CinqContent value)? success,
    TResult Function(CinqError value)? error,
  }) {
    return notInit?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CinqNotInit value)? notInit,
    TResult Function(CinqLoading value)? loading,
    TResult Function(CinqContent value)? success,
    TResult Function(CinqError value)? error,
    required TResult orElse(),
  }) {
    if (notInit != null) {
      return notInit(this);
    }
    return orElse();
  }
}

abstract class CinqNotInit implements Cinq {
  const factory CinqNotInit() = _$CinqNotInit;
}

/// @nodoc
abstract class _$$CinqLoadingCopyWith<$Res> {
  factory _$$CinqLoadingCopyWith(
          _$CinqLoading value, $Res Function(_$CinqLoading) then) =
      __$$CinqLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CinqLoadingCopyWithImpl<$Res> extends _$CinqCopyWithImpl<$Res>
    implements _$$CinqLoadingCopyWith<$Res> {
  __$$CinqLoadingCopyWithImpl(
      _$CinqLoading _value, $Res Function(_$CinqLoading) _then)
      : super(_value, (v) => _then(v as _$CinqLoading));

  @override
  _$CinqLoading get _value => super._value as _$CinqLoading;
}

/// @nodoc

class _$CinqLoading implements CinqLoading {
  const _$CinqLoading();

  @override
  String toString() {
    return 'Cinq.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CinqLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CinqNotInit value) notInit,
    required TResult Function(CinqLoading value) loading,
    required TResult Function(CinqContent value) success,
    required TResult Function(CinqError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(CinqNotInit value)? notInit,
    TResult Function(CinqLoading value)? loading,
    TResult Function(CinqContent value)? success,
    TResult Function(CinqError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CinqNotInit value)? notInit,
    TResult Function(CinqLoading value)? loading,
    TResult Function(CinqContent value)? success,
    TResult Function(CinqError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class CinqLoading implements Cinq {
  const factory CinqLoading() = _$CinqLoading;
}

/// @nodoc
abstract class _$$CinqContentCopyWith<$Res> {
  factory _$$CinqContentCopyWith(
          _$CinqContent value, $Res Function(_$CinqContent) then) =
      __$$CinqContentCopyWithImpl<$Res>;
  $Res call({Affichage affichage});

  $AffichageCopyWith<$Res> get affichage;
}

/// @nodoc
class __$$CinqContentCopyWithImpl<$Res> extends _$CinqCopyWithImpl<$Res>
    implements _$$CinqContentCopyWith<$Res> {
  __$$CinqContentCopyWithImpl(
      _$CinqContent _value, $Res Function(_$CinqContent) _then)
      : super(_value, (v) => _then(v as _$CinqContent));

  @override
  _$CinqContent get _value => super._value as _$CinqContent;

  @override
  $Res call({
    Object? affichage = freezed,
  }) {
    return _then(_$CinqContent(
      affichage == freezed
          ? _value.affichage
          : affichage // ignore: cast_nullable_to_non_nullable
              as Affichage,
    ));
  }

  @override
  $AffichageCopyWith<$Res> get affichage {
    return $AffichageCopyWith<$Res>(_value.affichage, (value) {
      return _then(_value.copyWith(affichage: value));
    });
  }
}

/// @nodoc

class _$CinqContent implements CinqContent {
  const _$CinqContent(this.affichage);

  @override
  final Affichage affichage;

  @override
  String toString() {
    return 'Cinq.success(affichage: $affichage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CinqContent &&
            const DeepCollectionEquality().equals(other.affichage, affichage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(affichage));

  @JsonKey(ignore: true)
  @override
  _$$CinqContentCopyWith<_$CinqContent> get copyWith =>
      __$$CinqContentCopyWithImpl<_$CinqContent>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return success(affichage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return success?.call(affichage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(affichage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CinqNotInit value) notInit,
    required TResult Function(CinqLoading value) loading,
    required TResult Function(CinqContent value) success,
    required TResult Function(CinqError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(CinqNotInit value)? notInit,
    TResult Function(CinqLoading value)? loading,
    TResult Function(CinqContent value)? success,
    TResult Function(CinqError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CinqNotInit value)? notInit,
    TResult Function(CinqLoading value)? loading,
    TResult Function(CinqContent value)? success,
    TResult Function(CinqError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class CinqContent implements Cinq {
  const factory CinqContent(final Affichage affichage) = _$CinqContent;

  Affichage get affichage;
  @JsonKey(ignore: true)
  _$$CinqContentCopyWith<_$CinqContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CinqErrorCopyWith<$Res> {
  factory _$$CinqErrorCopyWith(
          _$CinqError value, $Res Function(_$CinqError) then) =
      __$$CinqErrorCopyWithImpl<$Res>;
  $Res call({String message});
}

/// @nodoc
class __$$CinqErrorCopyWithImpl<$Res> extends _$CinqCopyWithImpl<$Res>
    implements _$$CinqErrorCopyWith<$Res> {
  __$$CinqErrorCopyWithImpl(
      _$CinqError _value, $Res Function(_$CinqError) _then)
      : super(_value, (v) => _then(v as _$CinqError));

  @override
  _$CinqError get _value => super._value as _$CinqError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$CinqError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CinqError implements CinqError {
  const _$CinqError(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Cinq.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CinqError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$$CinqErrorCopyWith<_$CinqError> get copyWith =>
      __$$CinqErrorCopyWithImpl<_$CinqError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CinqNotInit value) notInit,
    required TResult Function(CinqLoading value) loading,
    required TResult Function(CinqContent value) success,
    required TResult Function(CinqError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(CinqNotInit value)? notInit,
    TResult Function(CinqLoading value)? loading,
    TResult Function(CinqContent value)? success,
    TResult Function(CinqError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CinqNotInit value)? notInit,
    TResult Function(CinqLoading value)? loading,
    TResult Function(CinqContent value)? success,
    TResult Function(CinqError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class CinqError implements Cinq {
  const factory CinqError(final String message) = _$CinqError;

  String get message;
  @JsonKey(ignore: true)
  _$$CinqErrorCopyWith<_$CinqError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Six {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SixNotInit value) notInit,
    required TResult Function(SixLoading value) loading,
    required TResult Function(SixContent value) success,
    required TResult Function(SixError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SixNotInit value)? notInit,
    TResult Function(SixLoading value)? loading,
    TResult Function(SixContent value)? success,
    TResult Function(SixError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SixNotInit value)? notInit,
    TResult Function(SixLoading value)? loading,
    TResult Function(SixContent value)? success,
    TResult Function(SixError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SixCopyWith<$Res> {
  factory $SixCopyWith(Six value, $Res Function(Six) then) =
      _$SixCopyWithImpl<$Res>;
}

/// @nodoc
class _$SixCopyWithImpl<$Res> implements $SixCopyWith<$Res> {
  _$SixCopyWithImpl(this._value, this._then);

  final Six _value;
  // ignore: unused_field
  final $Res Function(Six) _then;
}

/// @nodoc
abstract class _$$SixNotInitCopyWith<$Res> {
  factory _$$SixNotInitCopyWith(
          _$SixNotInit value, $Res Function(_$SixNotInit) then) =
      __$$SixNotInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SixNotInitCopyWithImpl<$Res> extends _$SixCopyWithImpl<$Res>
    implements _$$SixNotInitCopyWith<$Res> {
  __$$SixNotInitCopyWithImpl(
      _$SixNotInit _value, $Res Function(_$SixNotInit) _then)
      : super(_value, (v) => _then(v as _$SixNotInit));

  @override
  _$SixNotInit get _value => super._value as _$SixNotInit;
}

/// @nodoc

class _$SixNotInit implements SixNotInit {
  const _$SixNotInit();

  @override
  String toString() {
    return 'Six.notInit()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SixNotInit);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return notInit();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return notInit?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (notInit != null) {
      return notInit();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SixNotInit value) notInit,
    required TResult Function(SixLoading value) loading,
    required TResult Function(SixContent value) success,
    required TResult Function(SixError value) error,
  }) {
    return notInit(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SixNotInit value)? notInit,
    TResult Function(SixLoading value)? loading,
    TResult Function(SixContent value)? success,
    TResult Function(SixError value)? error,
  }) {
    return notInit?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SixNotInit value)? notInit,
    TResult Function(SixLoading value)? loading,
    TResult Function(SixContent value)? success,
    TResult Function(SixError value)? error,
    required TResult orElse(),
  }) {
    if (notInit != null) {
      return notInit(this);
    }
    return orElse();
  }
}

abstract class SixNotInit implements Six {
  const factory SixNotInit() = _$SixNotInit;
}

/// @nodoc
abstract class _$$SixLoadingCopyWith<$Res> {
  factory _$$SixLoadingCopyWith(
          _$SixLoading value, $Res Function(_$SixLoading) then) =
      __$$SixLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SixLoadingCopyWithImpl<$Res> extends _$SixCopyWithImpl<$Res>
    implements _$$SixLoadingCopyWith<$Res> {
  __$$SixLoadingCopyWithImpl(
      _$SixLoading _value, $Res Function(_$SixLoading) _then)
      : super(_value, (v) => _then(v as _$SixLoading));

  @override
  _$SixLoading get _value => super._value as _$SixLoading;
}

/// @nodoc

class _$SixLoading implements SixLoading {
  const _$SixLoading();

  @override
  String toString() {
    return 'Six.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SixLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SixNotInit value) notInit,
    required TResult Function(SixLoading value) loading,
    required TResult Function(SixContent value) success,
    required TResult Function(SixError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SixNotInit value)? notInit,
    TResult Function(SixLoading value)? loading,
    TResult Function(SixContent value)? success,
    TResult Function(SixError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SixNotInit value)? notInit,
    TResult Function(SixLoading value)? loading,
    TResult Function(SixContent value)? success,
    TResult Function(SixError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class SixLoading implements Six {
  const factory SixLoading() = _$SixLoading;
}

/// @nodoc
abstract class _$$SixContentCopyWith<$Res> {
  factory _$$SixContentCopyWith(
          _$SixContent value, $Res Function(_$SixContent) then) =
      __$$SixContentCopyWithImpl<$Res>;
  $Res call({Affichage affichage});

  $AffichageCopyWith<$Res> get affichage;
}

/// @nodoc
class __$$SixContentCopyWithImpl<$Res> extends _$SixCopyWithImpl<$Res>
    implements _$$SixContentCopyWith<$Res> {
  __$$SixContentCopyWithImpl(
      _$SixContent _value, $Res Function(_$SixContent) _then)
      : super(_value, (v) => _then(v as _$SixContent));

  @override
  _$SixContent get _value => super._value as _$SixContent;

  @override
  $Res call({
    Object? affichage = freezed,
  }) {
    return _then(_$SixContent(
      affichage == freezed
          ? _value.affichage
          : affichage // ignore: cast_nullable_to_non_nullable
              as Affichage,
    ));
  }

  @override
  $AffichageCopyWith<$Res> get affichage {
    return $AffichageCopyWith<$Res>(_value.affichage, (value) {
      return _then(_value.copyWith(affichage: value));
    });
  }
}

/// @nodoc

class _$SixContent implements SixContent {
  const _$SixContent(this.affichage);

  @override
  final Affichage affichage;

  @override
  String toString() {
    return 'Six.success(affichage: $affichage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SixContent &&
            const DeepCollectionEquality().equals(other.affichage, affichage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(affichage));

  @JsonKey(ignore: true)
  @override
  _$$SixContentCopyWith<_$SixContent> get copyWith =>
      __$$SixContentCopyWithImpl<_$SixContent>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return success(affichage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return success?.call(affichage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(affichage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SixNotInit value) notInit,
    required TResult Function(SixLoading value) loading,
    required TResult Function(SixContent value) success,
    required TResult Function(SixError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SixNotInit value)? notInit,
    TResult Function(SixLoading value)? loading,
    TResult Function(SixContent value)? success,
    TResult Function(SixError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SixNotInit value)? notInit,
    TResult Function(SixLoading value)? loading,
    TResult Function(SixContent value)? success,
    TResult Function(SixError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class SixContent implements Six {
  const factory SixContent(final Affichage affichage) = _$SixContent;

  Affichage get affichage;
  @JsonKey(ignore: true)
  _$$SixContentCopyWith<_$SixContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SixErrorCopyWith<$Res> {
  factory _$$SixErrorCopyWith(
          _$SixError value, $Res Function(_$SixError) then) =
      __$$SixErrorCopyWithImpl<$Res>;
  $Res call({String message});
}

/// @nodoc
class __$$SixErrorCopyWithImpl<$Res> extends _$SixCopyWithImpl<$Res>
    implements _$$SixErrorCopyWith<$Res> {
  __$$SixErrorCopyWithImpl(_$SixError _value, $Res Function(_$SixError) _then)
      : super(_value, (v) => _then(v as _$SixError));

  @override
  _$SixError get _value => super._value as _$SixError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$SixError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SixError implements SixError {
  const _$SixError(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Six.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SixError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$$SixErrorCopyWith<_$SixError> get copyWith =>
      __$$SixErrorCopyWithImpl<_$SixError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SixNotInit value) notInit,
    required TResult Function(SixLoading value) loading,
    required TResult Function(SixContent value) success,
    required TResult Function(SixError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SixNotInit value)? notInit,
    TResult Function(SixLoading value)? loading,
    TResult Function(SixContent value)? success,
    TResult Function(SixError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SixNotInit value)? notInit,
    TResult Function(SixLoading value)? loading,
    TResult Function(SixContent value)? success,
    TResult Function(SixError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class SixError implements Six {
  const factory SixError(final String message) = _$SixError;

  String get message;
  @JsonKey(ignore: true)
  _$$SixErrorCopyWith<_$SixError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Sept {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SeptNotInit value) notInit,
    required TResult Function(SeptLoading value) loading,
    required TResult Function(SeptContent value) success,
    required TResult Function(SeptError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SeptNotInit value)? notInit,
    TResult Function(SeptLoading value)? loading,
    TResult Function(SeptContent value)? success,
    TResult Function(SeptError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SeptNotInit value)? notInit,
    TResult Function(SeptLoading value)? loading,
    TResult Function(SeptContent value)? success,
    TResult Function(SeptError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SeptCopyWith<$Res> {
  factory $SeptCopyWith(Sept value, $Res Function(Sept) then) =
      _$SeptCopyWithImpl<$Res>;
}

/// @nodoc
class _$SeptCopyWithImpl<$Res> implements $SeptCopyWith<$Res> {
  _$SeptCopyWithImpl(this._value, this._then);

  final Sept _value;
  // ignore: unused_field
  final $Res Function(Sept) _then;
}

/// @nodoc
abstract class _$$SeptNotInitCopyWith<$Res> {
  factory _$$SeptNotInitCopyWith(
          _$SeptNotInit value, $Res Function(_$SeptNotInit) then) =
      __$$SeptNotInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SeptNotInitCopyWithImpl<$Res> extends _$SeptCopyWithImpl<$Res>
    implements _$$SeptNotInitCopyWith<$Res> {
  __$$SeptNotInitCopyWithImpl(
      _$SeptNotInit _value, $Res Function(_$SeptNotInit) _then)
      : super(_value, (v) => _then(v as _$SeptNotInit));

  @override
  _$SeptNotInit get _value => super._value as _$SeptNotInit;
}

/// @nodoc

class _$SeptNotInit implements SeptNotInit {
  const _$SeptNotInit();

  @override
  String toString() {
    return 'Sept.notInit()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SeptNotInit);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return notInit();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return notInit?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (notInit != null) {
      return notInit();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SeptNotInit value) notInit,
    required TResult Function(SeptLoading value) loading,
    required TResult Function(SeptContent value) success,
    required TResult Function(SeptError value) error,
  }) {
    return notInit(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SeptNotInit value)? notInit,
    TResult Function(SeptLoading value)? loading,
    TResult Function(SeptContent value)? success,
    TResult Function(SeptError value)? error,
  }) {
    return notInit?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SeptNotInit value)? notInit,
    TResult Function(SeptLoading value)? loading,
    TResult Function(SeptContent value)? success,
    TResult Function(SeptError value)? error,
    required TResult orElse(),
  }) {
    if (notInit != null) {
      return notInit(this);
    }
    return orElse();
  }
}

abstract class SeptNotInit implements Sept {
  const factory SeptNotInit() = _$SeptNotInit;
}

/// @nodoc
abstract class _$$SeptLoadingCopyWith<$Res> {
  factory _$$SeptLoadingCopyWith(
          _$SeptLoading value, $Res Function(_$SeptLoading) then) =
      __$$SeptLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SeptLoadingCopyWithImpl<$Res> extends _$SeptCopyWithImpl<$Res>
    implements _$$SeptLoadingCopyWith<$Res> {
  __$$SeptLoadingCopyWithImpl(
      _$SeptLoading _value, $Res Function(_$SeptLoading) _then)
      : super(_value, (v) => _then(v as _$SeptLoading));

  @override
  _$SeptLoading get _value => super._value as _$SeptLoading;
}

/// @nodoc

class _$SeptLoading implements SeptLoading {
  const _$SeptLoading();

  @override
  String toString() {
    return 'Sept.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SeptLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SeptNotInit value) notInit,
    required TResult Function(SeptLoading value) loading,
    required TResult Function(SeptContent value) success,
    required TResult Function(SeptError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SeptNotInit value)? notInit,
    TResult Function(SeptLoading value)? loading,
    TResult Function(SeptContent value)? success,
    TResult Function(SeptError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SeptNotInit value)? notInit,
    TResult Function(SeptLoading value)? loading,
    TResult Function(SeptContent value)? success,
    TResult Function(SeptError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class SeptLoading implements Sept {
  const factory SeptLoading() = _$SeptLoading;
}

/// @nodoc
abstract class _$$SeptContentCopyWith<$Res> {
  factory _$$SeptContentCopyWith(
          _$SeptContent value, $Res Function(_$SeptContent) then) =
      __$$SeptContentCopyWithImpl<$Res>;
  $Res call({Affichage affichage});

  $AffichageCopyWith<$Res> get affichage;
}

/// @nodoc
class __$$SeptContentCopyWithImpl<$Res> extends _$SeptCopyWithImpl<$Res>
    implements _$$SeptContentCopyWith<$Res> {
  __$$SeptContentCopyWithImpl(
      _$SeptContent _value, $Res Function(_$SeptContent) _then)
      : super(_value, (v) => _then(v as _$SeptContent));

  @override
  _$SeptContent get _value => super._value as _$SeptContent;

  @override
  $Res call({
    Object? affichage = freezed,
  }) {
    return _then(_$SeptContent(
      affichage == freezed
          ? _value.affichage
          : affichage // ignore: cast_nullable_to_non_nullable
              as Affichage,
    ));
  }

  @override
  $AffichageCopyWith<$Res> get affichage {
    return $AffichageCopyWith<$Res>(_value.affichage, (value) {
      return _then(_value.copyWith(affichage: value));
    });
  }
}

/// @nodoc

class _$SeptContent implements SeptContent {
  const _$SeptContent(this.affichage);

  @override
  final Affichage affichage;

  @override
  String toString() {
    return 'Sept.success(affichage: $affichage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SeptContent &&
            const DeepCollectionEquality().equals(other.affichage, affichage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(affichage));

  @JsonKey(ignore: true)
  @override
  _$$SeptContentCopyWith<_$SeptContent> get copyWith =>
      __$$SeptContentCopyWithImpl<_$SeptContent>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return success(affichage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return success?.call(affichage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(affichage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SeptNotInit value) notInit,
    required TResult Function(SeptLoading value) loading,
    required TResult Function(SeptContent value) success,
    required TResult Function(SeptError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SeptNotInit value)? notInit,
    TResult Function(SeptLoading value)? loading,
    TResult Function(SeptContent value)? success,
    TResult Function(SeptError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SeptNotInit value)? notInit,
    TResult Function(SeptLoading value)? loading,
    TResult Function(SeptContent value)? success,
    TResult Function(SeptError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class SeptContent implements Sept {
  const factory SeptContent(final Affichage affichage) = _$SeptContent;

  Affichage get affichage;
  @JsonKey(ignore: true)
  _$$SeptContentCopyWith<_$SeptContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SeptErrorCopyWith<$Res> {
  factory _$$SeptErrorCopyWith(
          _$SeptError value, $Res Function(_$SeptError) then) =
      __$$SeptErrorCopyWithImpl<$Res>;
  $Res call({String message});
}

/// @nodoc
class __$$SeptErrorCopyWithImpl<$Res> extends _$SeptCopyWithImpl<$Res>
    implements _$$SeptErrorCopyWith<$Res> {
  __$$SeptErrorCopyWithImpl(
      _$SeptError _value, $Res Function(_$SeptError) _then)
      : super(_value, (v) => _then(v as _$SeptError));

  @override
  _$SeptError get _value => super._value as _$SeptError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$SeptError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SeptError implements SeptError {
  const _$SeptError(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Sept.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SeptError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$$SeptErrorCopyWith<_$SeptError> get copyWith =>
      __$$SeptErrorCopyWithImpl<_$SeptError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SeptNotInit value) notInit,
    required TResult Function(SeptLoading value) loading,
    required TResult Function(SeptContent value) success,
    required TResult Function(SeptError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(SeptNotInit value)? notInit,
    TResult Function(SeptLoading value)? loading,
    TResult Function(SeptContent value)? success,
    TResult Function(SeptError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SeptNotInit value)? notInit,
    TResult Function(SeptLoading value)? loading,
    TResult Function(SeptContent value)? success,
    TResult Function(SeptError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class SeptError implements Sept {
  const factory SeptError(final String message) = _$SeptError;

  String get message;
  @JsonKey(ignore: true)
  _$$SeptErrorCopyWith<_$SeptError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Huit {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HuitNotInit value) notInit,
    required TResult Function(HuitLoading value) loading,
    required TResult Function(HuitContent value) success,
    required TResult Function(HuitError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(HuitNotInit value)? notInit,
    TResult Function(HuitLoading value)? loading,
    TResult Function(HuitContent value)? success,
    TResult Function(HuitError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HuitNotInit value)? notInit,
    TResult Function(HuitLoading value)? loading,
    TResult Function(HuitContent value)? success,
    TResult Function(HuitError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HuitCopyWith<$Res> {
  factory $HuitCopyWith(Huit value, $Res Function(Huit) then) =
      _$HuitCopyWithImpl<$Res>;
}

/// @nodoc
class _$HuitCopyWithImpl<$Res> implements $HuitCopyWith<$Res> {
  _$HuitCopyWithImpl(this._value, this._then);

  final Huit _value;
  // ignore: unused_field
  final $Res Function(Huit) _then;
}

/// @nodoc
abstract class _$$HuitNotInitCopyWith<$Res> {
  factory _$$HuitNotInitCopyWith(
          _$HuitNotInit value, $Res Function(_$HuitNotInit) then) =
      __$$HuitNotInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$$HuitNotInitCopyWithImpl<$Res> extends _$HuitCopyWithImpl<$Res>
    implements _$$HuitNotInitCopyWith<$Res> {
  __$$HuitNotInitCopyWithImpl(
      _$HuitNotInit _value, $Res Function(_$HuitNotInit) _then)
      : super(_value, (v) => _then(v as _$HuitNotInit));

  @override
  _$HuitNotInit get _value => super._value as _$HuitNotInit;
}

/// @nodoc

class _$HuitNotInit implements HuitNotInit {
  const _$HuitNotInit();

  @override
  String toString() {
    return 'Huit.notInit()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$HuitNotInit);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return notInit();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return notInit?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (notInit != null) {
      return notInit();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HuitNotInit value) notInit,
    required TResult Function(HuitLoading value) loading,
    required TResult Function(HuitContent value) success,
    required TResult Function(HuitError value) error,
  }) {
    return notInit(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(HuitNotInit value)? notInit,
    TResult Function(HuitLoading value)? loading,
    TResult Function(HuitContent value)? success,
    TResult Function(HuitError value)? error,
  }) {
    return notInit?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HuitNotInit value)? notInit,
    TResult Function(HuitLoading value)? loading,
    TResult Function(HuitContent value)? success,
    TResult Function(HuitError value)? error,
    required TResult orElse(),
  }) {
    if (notInit != null) {
      return notInit(this);
    }
    return orElse();
  }
}

abstract class HuitNotInit implements Huit {
  const factory HuitNotInit() = _$HuitNotInit;
}

/// @nodoc
abstract class _$$HuitLoadingCopyWith<$Res> {
  factory _$$HuitLoadingCopyWith(
          _$HuitLoading value, $Res Function(_$HuitLoading) then) =
      __$$HuitLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$$HuitLoadingCopyWithImpl<$Res> extends _$HuitCopyWithImpl<$Res>
    implements _$$HuitLoadingCopyWith<$Res> {
  __$$HuitLoadingCopyWithImpl(
      _$HuitLoading _value, $Res Function(_$HuitLoading) _then)
      : super(_value, (v) => _then(v as _$HuitLoading));

  @override
  _$HuitLoading get _value => super._value as _$HuitLoading;
}

/// @nodoc

class _$HuitLoading implements HuitLoading {
  const _$HuitLoading();

  @override
  String toString() {
    return 'Huit.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$HuitLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HuitNotInit value) notInit,
    required TResult Function(HuitLoading value) loading,
    required TResult Function(HuitContent value) success,
    required TResult Function(HuitError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(HuitNotInit value)? notInit,
    TResult Function(HuitLoading value)? loading,
    TResult Function(HuitContent value)? success,
    TResult Function(HuitError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HuitNotInit value)? notInit,
    TResult Function(HuitLoading value)? loading,
    TResult Function(HuitContent value)? success,
    TResult Function(HuitError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class HuitLoading implements Huit {
  const factory HuitLoading() = _$HuitLoading;
}

/// @nodoc
abstract class _$$HuitContentCopyWith<$Res> {
  factory _$$HuitContentCopyWith(
          _$HuitContent value, $Res Function(_$HuitContent) then) =
      __$$HuitContentCopyWithImpl<$Res>;
  $Res call({Affichage affichage});

  $AffichageCopyWith<$Res> get affichage;
}

/// @nodoc
class __$$HuitContentCopyWithImpl<$Res> extends _$HuitCopyWithImpl<$Res>
    implements _$$HuitContentCopyWith<$Res> {
  __$$HuitContentCopyWithImpl(
      _$HuitContent _value, $Res Function(_$HuitContent) _then)
      : super(_value, (v) => _then(v as _$HuitContent));

  @override
  _$HuitContent get _value => super._value as _$HuitContent;

  @override
  $Res call({
    Object? affichage = freezed,
  }) {
    return _then(_$HuitContent(
      affichage == freezed
          ? _value.affichage
          : affichage // ignore: cast_nullable_to_non_nullable
              as Affichage,
    ));
  }

  @override
  $AffichageCopyWith<$Res> get affichage {
    return $AffichageCopyWith<$Res>(_value.affichage, (value) {
      return _then(_value.copyWith(affichage: value));
    });
  }
}

/// @nodoc

class _$HuitContent implements HuitContent {
  const _$HuitContent(this.affichage);

  @override
  final Affichage affichage;

  @override
  String toString() {
    return 'Huit.success(affichage: $affichage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HuitContent &&
            const DeepCollectionEquality().equals(other.affichage, affichage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(affichage));

  @JsonKey(ignore: true)
  @override
  _$$HuitContentCopyWith<_$HuitContent> get copyWith =>
      __$$HuitContentCopyWithImpl<_$HuitContent>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return success(affichage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return success?.call(affichage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(affichage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HuitNotInit value) notInit,
    required TResult Function(HuitLoading value) loading,
    required TResult Function(HuitContent value) success,
    required TResult Function(HuitError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(HuitNotInit value)? notInit,
    TResult Function(HuitLoading value)? loading,
    TResult Function(HuitContent value)? success,
    TResult Function(HuitError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HuitNotInit value)? notInit,
    TResult Function(HuitLoading value)? loading,
    TResult Function(HuitContent value)? success,
    TResult Function(HuitError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class HuitContent implements Huit {
  const factory HuitContent(final Affichage affichage) = _$HuitContent;

  Affichage get affichage;
  @JsonKey(ignore: true)
  _$$HuitContentCopyWith<_$HuitContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$HuitErrorCopyWith<$Res> {
  factory _$$HuitErrorCopyWith(
          _$HuitError value, $Res Function(_$HuitError) then) =
      __$$HuitErrorCopyWithImpl<$Res>;
  $Res call({String message});
}

/// @nodoc
class __$$HuitErrorCopyWithImpl<$Res> extends _$HuitCopyWithImpl<$Res>
    implements _$$HuitErrorCopyWith<$Res> {
  __$$HuitErrorCopyWithImpl(
      _$HuitError _value, $Res Function(_$HuitError) _then)
      : super(_value, (v) => _then(v as _$HuitError));

  @override
  _$HuitError get _value => super._value as _$HuitError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$HuitError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$HuitError implements HuitError {
  const _$HuitError(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Huit.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HuitError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$$HuitErrorCopyWith<_$HuitError> get copyWith =>
      __$$HuitErrorCopyWithImpl<_$HuitError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HuitNotInit value) notInit,
    required TResult Function(HuitLoading value) loading,
    required TResult Function(HuitContent value) success,
    required TResult Function(HuitError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(HuitNotInit value)? notInit,
    TResult Function(HuitLoading value)? loading,
    TResult Function(HuitContent value)? success,
    TResult Function(HuitError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HuitNotInit value)? notInit,
    TResult Function(HuitLoading value)? loading,
    TResult Function(HuitContent value)? success,
    TResult Function(HuitError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class HuitError implements Huit {
  const factory HuitError(final String message) = _$HuitError;

  String get message;
  @JsonKey(ignore: true)
  _$$HuitErrorCopyWith<_$HuitError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Neuf {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NeufNotInit value) notInit,
    required TResult Function(NeufLoading value) loading,
    required TResult Function(NeufContent value) success,
    required TResult Function(NeufError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(NeufNotInit value)? notInit,
    TResult Function(NeufLoading value)? loading,
    TResult Function(NeufContent value)? success,
    TResult Function(NeufError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NeufNotInit value)? notInit,
    TResult Function(NeufLoading value)? loading,
    TResult Function(NeufContent value)? success,
    TResult Function(NeufError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NeufCopyWith<$Res> {
  factory $NeufCopyWith(Neuf value, $Res Function(Neuf) then) =
      _$NeufCopyWithImpl<$Res>;
}

/// @nodoc
class _$NeufCopyWithImpl<$Res> implements $NeufCopyWith<$Res> {
  _$NeufCopyWithImpl(this._value, this._then);

  final Neuf _value;
  // ignore: unused_field
  final $Res Function(Neuf) _then;
}

/// @nodoc
abstract class _$$NeufNotInitCopyWith<$Res> {
  factory _$$NeufNotInitCopyWith(
          _$NeufNotInit value, $Res Function(_$NeufNotInit) then) =
      __$$NeufNotInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NeufNotInitCopyWithImpl<$Res> extends _$NeufCopyWithImpl<$Res>
    implements _$$NeufNotInitCopyWith<$Res> {
  __$$NeufNotInitCopyWithImpl(
      _$NeufNotInit _value, $Res Function(_$NeufNotInit) _then)
      : super(_value, (v) => _then(v as _$NeufNotInit));

  @override
  _$NeufNotInit get _value => super._value as _$NeufNotInit;
}

/// @nodoc

class _$NeufNotInit implements NeufNotInit {
  const _$NeufNotInit();

  @override
  String toString() {
    return 'Neuf.notInit()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$NeufNotInit);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return notInit();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return notInit?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (notInit != null) {
      return notInit();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NeufNotInit value) notInit,
    required TResult Function(NeufLoading value) loading,
    required TResult Function(NeufContent value) success,
    required TResult Function(NeufError value) error,
  }) {
    return notInit(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(NeufNotInit value)? notInit,
    TResult Function(NeufLoading value)? loading,
    TResult Function(NeufContent value)? success,
    TResult Function(NeufError value)? error,
  }) {
    return notInit?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NeufNotInit value)? notInit,
    TResult Function(NeufLoading value)? loading,
    TResult Function(NeufContent value)? success,
    TResult Function(NeufError value)? error,
    required TResult orElse(),
  }) {
    if (notInit != null) {
      return notInit(this);
    }
    return orElse();
  }
}

abstract class NeufNotInit implements Neuf {
  const factory NeufNotInit() = _$NeufNotInit;
}

/// @nodoc
abstract class _$$NeufLoadingCopyWith<$Res> {
  factory _$$NeufLoadingCopyWith(
          _$NeufLoading value, $Res Function(_$NeufLoading) then) =
      __$$NeufLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NeufLoadingCopyWithImpl<$Res> extends _$NeufCopyWithImpl<$Res>
    implements _$$NeufLoadingCopyWith<$Res> {
  __$$NeufLoadingCopyWithImpl(
      _$NeufLoading _value, $Res Function(_$NeufLoading) _then)
      : super(_value, (v) => _then(v as _$NeufLoading));

  @override
  _$NeufLoading get _value => super._value as _$NeufLoading;
}

/// @nodoc

class _$NeufLoading implements NeufLoading {
  const _$NeufLoading();

  @override
  String toString() {
    return 'Neuf.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$NeufLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NeufNotInit value) notInit,
    required TResult Function(NeufLoading value) loading,
    required TResult Function(NeufContent value) success,
    required TResult Function(NeufError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(NeufNotInit value)? notInit,
    TResult Function(NeufLoading value)? loading,
    TResult Function(NeufContent value)? success,
    TResult Function(NeufError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NeufNotInit value)? notInit,
    TResult Function(NeufLoading value)? loading,
    TResult Function(NeufContent value)? success,
    TResult Function(NeufError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class NeufLoading implements Neuf {
  const factory NeufLoading() = _$NeufLoading;
}

/// @nodoc
abstract class _$$NeufContentCopyWith<$Res> {
  factory _$$NeufContentCopyWith(
          _$NeufContent value, $Res Function(_$NeufContent) then) =
      __$$NeufContentCopyWithImpl<$Res>;
  $Res call({Affichage affichage});

  $AffichageCopyWith<$Res> get affichage;
}

/// @nodoc
class __$$NeufContentCopyWithImpl<$Res> extends _$NeufCopyWithImpl<$Res>
    implements _$$NeufContentCopyWith<$Res> {
  __$$NeufContentCopyWithImpl(
      _$NeufContent _value, $Res Function(_$NeufContent) _then)
      : super(_value, (v) => _then(v as _$NeufContent));

  @override
  _$NeufContent get _value => super._value as _$NeufContent;

  @override
  $Res call({
    Object? affichage = freezed,
  }) {
    return _then(_$NeufContent(
      affichage == freezed
          ? _value.affichage
          : affichage // ignore: cast_nullable_to_non_nullable
              as Affichage,
    ));
  }

  @override
  $AffichageCopyWith<$Res> get affichage {
    return $AffichageCopyWith<$Res>(_value.affichage, (value) {
      return _then(_value.copyWith(affichage: value));
    });
  }
}

/// @nodoc

class _$NeufContent implements NeufContent {
  const _$NeufContent(this.affichage);

  @override
  final Affichage affichage;

  @override
  String toString() {
    return 'Neuf.success(affichage: $affichage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NeufContent &&
            const DeepCollectionEquality().equals(other.affichage, affichage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(affichage));

  @JsonKey(ignore: true)
  @override
  _$$NeufContentCopyWith<_$NeufContent> get copyWith =>
      __$$NeufContentCopyWithImpl<_$NeufContent>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return success(affichage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return success?.call(affichage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(affichage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NeufNotInit value) notInit,
    required TResult Function(NeufLoading value) loading,
    required TResult Function(NeufContent value) success,
    required TResult Function(NeufError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(NeufNotInit value)? notInit,
    TResult Function(NeufLoading value)? loading,
    TResult Function(NeufContent value)? success,
    TResult Function(NeufError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NeufNotInit value)? notInit,
    TResult Function(NeufLoading value)? loading,
    TResult Function(NeufContent value)? success,
    TResult Function(NeufError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class NeufContent implements Neuf {
  const factory NeufContent(final Affichage affichage) = _$NeufContent;

  Affichage get affichage;
  @JsonKey(ignore: true)
  _$$NeufContentCopyWith<_$NeufContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NeufErrorCopyWith<$Res> {
  factory _$$NeufErrorCopyWith(
          _$NeufError value, $Res Function(_$NeufError) then) =
      __$$NeufErrorCopyWithImpl<$Res>;
  $Res call({String message});
}

/// @nodoc
class __$$NeufErrorCopyWithImpl<$Res> extends _$NeufCopyWithImpl<$Res>
    implements _$$NeufErrorCopyWith<$Res> {
  __$$NeufErrorCopyWithImpl(
      _$NeufError _value, $Res Function(_$NeufError) _then)
      : super(_value, (v) => _then(v as _$NeufError));

  @override
  _$NeufError get _value => super._value as _$NeufError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$NeufError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$NeufError implements NeufError {
  const _$NeufError(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Neuf.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NeufError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$$NeufErrorCopyWith<_$NeufError> get copyWith =>
      __$$NeufErrorCopyWithImpl<_$NeufError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NeufNotInit value) notInit,
    required TResult Function(NeufLoading value) loading,
    required TResult Function(NeufContent value) success,
    required TResult Function(NeufError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(NeufNotInit value)? notInit,
    TResult Function(NeufLoading value)? loading,
    TResult Function(NeufContent value)? success,
    TResult Function(NeufError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NeufNotInit value)? notInit,
    TResult Function(NeufLoading value)? loading,
    TResult Function(NeufContent value)? success,
    TResult Function(NeufError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class NeufError implements Neuf {
  const factory NeufError(final String message) = _$NeufError;

  String get message;
  @JsonKey(ignore: true)
  _$$NeufErrorCopyWith<_$NeufError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Dix {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DixNotInit value) notInit,
    required TResult Function(DixLoading value) loading,
    required TResult Function(DixContent value) success,
    required TResult Function(DixError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DixNotInit value)? notInit,
    TResult Function(DixLoading value)? loading,
    TResult Function(DixContent value)? success,
    TResult Function(DixError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DixNotInit value)? notInit,
    TResult Function(DixLoading value)? loading,
    TResult Function(DixContent value)? success,
    TResult Function(DixError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DixCopyWith<$Res> {
  factory $DixCopyWith(Dix value, $Res Function(Dix) then) =
      _$DixCopyWithImpl<$Res>;
}

/// @nodoc
class _$DixCopyWithImpl<$Res> implements $DixCopyWith<$Res> {
  _$DixCopyWithImpl(this._value, this._then);

  final Dix _value;
  // ignore: unused_field
  final $Res Function(Dix) _then;
}

/// @nodoc
abstract class _$$DixNotInitCopyWith<$Res> {
  factory _$$DixNotInitCopyWith(
          _$DixNotInit value, $Res Function(_$DixNotInit) then) =
      __$$DixNotInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DixNotInitCopyWithImpl<$Res> extends _$DixCopyWithImpl<$Res>
    implements _$$DixNotInitCopyWith<$Res> {
  __$$DixNotInitCopyWithImpl(
      _$DixNotInit _value, $Res Function(_$DixNotInit) _then)
      : super(_value, (v) => _then(v as _$DixNotInit));

  @override
  _$DixNotInit get _value => super._value as _$DixNotInit;
}

/// @nodoc

class _$DixNotInit implements DixNotInit {
  const _$DixNotInit();

  @override
  String toString() {
    return 'Dix.notInit()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DixNotInit);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return notInit();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return notInit?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (notInit != null) {
      return notInit();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DixNotInit value) notInit,
    required TResult Function(DixLoading value) loading,
    required TResult Function(DixContent value) success,
    required TResult Function(DixError value) error,
  }) {
    return notInit(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DixNotInit value)? notInit,
    TResult Function(DixLoading value)? loading,
    TResult Function(DixContent value)? success,
    TResult Function(DixError value)? error,
  }) {
    return notInit?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DixNotInit value)? notInit,
    TResult Function(DixLoading value)? loading,
    TResult Function(DixContent value)? success,
    TResult Function(DixError value)? error,
    required TResult orElse(),
  }) {
    if (notInit != null) {
      return notInit(this);
    }
    return orElse();
  }
}

abstract class DixNotInit implements Dix {
  const factory DixNotInit() = _$DixNotInit;
}

/// @nodoc
abstract class _$$DixLoadingCopyWith<$Res> {
  factory _$$DixLoadingCopyWith(
          _$DixLoading value, $Res Function(_$DixLoading) then) =
      __$$DixLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DixLoadingCopyWithImpl<$Res> extends _$DixCopyWithImpl<$Res>
    implements _$$DixLoadingCopyWith<$Res> {
  __$$DixLoadingCopyWithImpl(
      _$DixLoading _value, $Res Function(_$DixLoading) _then)
      : super(_value, (v) => _then(v as _$DixLoading));

  @override
  _$DixLoading get _value => super._value as _$DixLoading;
}

/// @nodoc

class _$DixLoading implements DixLoading {
  const _$DixLoading();

  @override
  String toString() {
    return 'Dix.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DixLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DixNotInit value) notInit,
    required TResult Function(DixLoading value) loading,
    required TResult Function(DixContent value) success,
    required TResult Function(DixError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DixNotInit value)? notInit,
    TResult Function(DixLoading value)? loading,
    TResult Function(DixContent value)? success,
    TResult Function(DixError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DixNotInit value)? notInit,
    TResult Function(DixLoading value)? loading,
    TResult Function(DixContent value)? success,
    TResult Function(DixError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class DixLoading implements Dix {
  const factory DixLoading() = _$DixLoading;
}

/// @nodoc
abstract class _$$DixContentCopyWith<$Res> {
  factory _$$DixContentCopyWith(
          _$DixContent value, $Res Function(_$DixContent) then) =
      __$$DixContentCopyWithImpl<$Res>;
  $Res call({Affichage affichage});

  $AffichageCopyWith<$Res> get affichage;
}

/// @nodoc
class __$$DixContentCopyWithImpl<$Res> extends _$DixCopyWithImpl<$Res>
    implements _$$DixContentCopyWith<$Res> {
  __$$DixContentCopyWithImpl(
      _$DixContent _value, $Res Function(_$DixContent) _then)
      : super(_value, (v) => _then(v as _$DixContent));

  @override
  _$DixContent get _value => super._value as _$DixContent;

  @override
  $Res call({
    Object? affichage = freezed,
  }) {
    return _then(_$DixContent(
      affichage == freezed
          ? _value.affichage
          : affichage // ignore: cast_nullable_to_non_nullable
              as Affichage,
    ));
  }

  @override
  $AffichageCopyWith<$Res> get affichage {
    return $AffichageCopyWith<$Res>(_value.affichage, (value) {
      return _then(_value.copyWith(affichage: value));
    });
  }
}

/// @nodoc

class _$DixContent implements DixContent {
  const _$DixContent(this.affichage);

  @override
  final Affichage affichage;

  @override
  String toString() {
    return 'Dix.success(affichage: $affichage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DixContent &&
            const DeepCollectionEquality().equals(other.affichage, affichage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(affichage));

  @JsonKey(ignore: true)
  @override
  _$$DixContentCopyWith<_$DixContent> get copyWith =>
      __$$DixContentCopyWithImpl<_$DixContent>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return success(affichage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return success?.call(affichage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(affichage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DixNotInit value) notInit,
    required TResult Function(DixLoading value) loading,
    required TResult Function(DixContent value) success,
    required TResult Function(DixError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DixNotInit value)? notInit,
    TResult Function(DixLoading value)? loading,
    TResult Function(DixContent value)? success,
    TResult Function(DixError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DixNotInit value)? notInit,
    TResult Function(DixLoading value)? loading,
    TResult Function(DixContent value)? success,
    TResult Function(DixError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class DixContent implements Dix {
  const factory DixContent(final Affichage affichage) = _$DixContent;

  Affichage get affichage;
  @JsonKey(ignore: true)
  _$$DixContentCopyWith<_$DixContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DixErrorCopyWith<$Res> {
  factory _$$DixErrorCopyWith(
          _$DixError value, $Res Function(_$DixError) then) =
      __$$DixErrorCopyWithImpl<$Res>;
  $Res call({String message});
}

/// @nodoc
class __$$DixErrorCopyWithImpl<$Res> extends _$DixCopyWithImpl<$Res>
    implements _$$DixErrorCopyWith<$Res> {
  __$$DixErrorCopyWithImpl(_$DixError _value, $Res Function(_$DixError) _then)
      : super(_value, (v) => _then(v as _$DixError));

  @override
  _$DixError get _value => super._value as _$DixError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$DixError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DixError implements DixError {
  const _$DixError(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Dix.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DixError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$$DixErrorCopyWith<_$DixError> get copyWith =>
      __$$DixErrorCopyWithImpl<_$DixError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DixNotInit value) notInit,
    required TResult Function(DixLoading value) loading,
    required TResult Function(DixContent value) success,
    required TResult Function(DixError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DixNotInit value)? notInit,
    TResult Function(DixLoading value)? loading,
    TResult Function(DixContent value)? success,
    TResult Function(DixError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DixNotInit value)? notInit,
    TResult Function(DixLoading value)? loading,
    TResult Function(DixContent value)? success,
    TResult Function(DixError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class DixError implements Dix {
  const factory DixError(final String message) = _$DixError;

  String get message;
  @JsonKey(ignore: true)
  _$$DixErrorCopyWith<_$DixError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Onze {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnzeNotInit value) notInit,
    required TResult Function(OnzeLoading value) loading,
    required TResult Function(OnzeContent value) success,
    required TResult Function(OnzeError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(OnzeNotInit value)? notInit,
    TResult Function(OnzeLoading value)? loading,
    TResult Function(OnzeContent value)? success,
    TResult Function(OnzeError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnzeNotInit value)? notInit,
    TResult Function(OnzeLoading value)? loading,
    TResult Function(OnzeContent value)? success,
    TResult Function(OnzeError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnzeCopyWith<$Res> {
  factory $OnzeCopyWith(Onze value, $Res Function(Onze) then) =
      _$OnzeCopyWithImpl<$Res>;
}

/// @nodoc
class _$OnzeCopyWithImpl<$Res> implements $OnzeCopyWith<$Res> {
  _$OnzeCopyWithImpl(this._value, this._then);

  final Onze _value;
  // ignore: unused_field
  final $Res Function(Onze) _then;
}

/// @nodoc
abstract class _$$OnzeNotInitCopyWith<$Res> {
  factory _$$OnzeNotInitCopyWith(
          _$OnzeNotInit value, $Res Function(_$OnzeNotInit) then) =
      __$$OnzeNotInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OnzeNotInitCopyWithImpl<$Res> extends _$OnzeCopyWithImpl<$Res>
    implements _$$OnzeNotInitCopyWith<$Res> {
  __$$OnzeNotInitCopyWithImpl(
      _$OnzeNotInit _value, $Res Function(_$OnzeNotInit) _then)
      : super(_value, (v) => _then(v as _$OnzeNotInit));

  @override
  _$OnzeNotInit get _value => super._value as _$OnzeNotInit;
}

/// @nodoc

class _$OnzeNotInit implements OnzeNotInit {
  const _$OnzeNotInit();

  @override
  String toString() {
    return 'Onze.notInit()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$OnzeNotInit);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return notInit();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return notInit?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (notInit != null) {
      return notInit();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnzeNotInit value) notInit,
    required TResult Function(OnzeLoading value) loading,
    required TResult Function(OnzeContent value) success,
    required TResult Function(OnzeError value) error,
  }) {
    return notInit(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(OnzeNotInit value)? notInit,
    TResult Function(OnzeLoading value)? loading,
    TResult Function(OnzeContent value)? success,
    TResult Function(OnzeError value)? error,
  }) {
    return notInit?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnzeNotInit value)? notInit,
    TResult Function(OnzeLoading value)? loading,
    TResult Function(OnzeContent value)? success,
    TResult Function(OnzeError value)? error,
    required TResult orElse(),
  }) {
    if (notInit != null) {
      return notInit(this);
    }
    return orElse();
  }
}

abstract class OnzeNotInit implements Onze {
  const factory OnzeNotInit() = _$OnzeNotInit;
}

/// @nodoc
abstract class _$$OnzeLoadingCopyWith<$Res> {
  factory _$$OnzeLoadingCopyWith(
          _$OnzeLoading value, $Res Function(_$OnzeLoading) then) =
      __$$OnzeLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OnzeLoadingCopyWithImpl<$Res> extends _$OnzeCopyWithImpl<$Res>
    implements _$$OnzeLoadingCopyWith<$Res> {
  __$$OnzeLoadingCopyWithImpl(
      _$OnzeLoading _value, $Res Function(_$OnzeLoading) _then)
      : super(_value, (v) => _then(v as _$OnzeLoading));

  @override
  _$OnzeLoading get _value => super._value as _$OnzeLoading;
}

/// @nodoc

class _$OnzeLoading implements OnzeLoading {
  const _$OnzeLoading();

  @override
  String toString() {
    return 'Onze.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$OnzeLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnzeNotInit value) notInit,
    required TResult Function(OnzeLoading value) loading,
    required TResult Function(OnzeContent value) success,
    required TResult Function(OnzeError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(OnzeNotInit value)? notInit,
    TResult Function(OnzeLoading value)? loading,
    TResult Function(OnzeContent value)? success,
    TResult Function(OnzeError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnzeNotInit value)? notInit,
    TResult Function(OnzeLoading value)? loading,
    TResult Function(OnzeContent value)? success,
    TResult Function(OnzeError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class OnzeLoading implements Onze {
  const factory OnzeLoading() = _$OnzeLoading;
}

/// @nodoc
abstract class _$$OnzeContentCopyWith<$Res> {
  factory _$$OnzeContentCopyWith(
          _$OnzeContent value, $Res Function(_$OnzeContent) then) =
      __$$OnzeContentCopyWithImpl<$Res>;
  $Res call({Affichage affichage});

  $AffichageCopyWith<$Res> get affichage;
}

/// @nodoc
class __$$OnzeContentCopyWithImpl<$Res> extends _$OnzeCopyWithImpl<$Res>
    implements _$$OnzeContentCopyWith<$Res> {
  __$$OnzeContentCopyWithImpl(
      _$OnzeContent _value, $Res Function(_$OnzeContent) _then)
      : super(_value, (v) => _then(v as _$OnzeContent));

  @override
  _$OnzeContent get _value => super._value as _$OnzeContent;

  @override
  $Res call({
    Object? affichage = freezed,
  }) {
    return _then(_$OnzeContent(
      affichage == freezed
          ? _value.affichage
          : affichage // ignore: cast_nullable_to_non_nullable
              as Affichage,
    ));
  }

  @override
  $AffichageCopyWith<$Res> get affichage {
    return $AffichageCopyWith<$Res>(_value.affichage, (value) {
      return _then(_value.copyWith(affichage: value));
    });
  }
}

/// @nodoc

class _$OnzeContent implements OnzeContent {
  const _$OnzeContent(this.affichage);

  @override
  final Affichage affichage;

  @override
  String toString() {
    return 'Onze.success(affichage: $affichage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnzeContent &&
            const DeepCollectionEquality().equals(other.affichage, affichage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(affichage));

  @JsonKey(ignore: true)
  @override
  _$$OnzeContentCopyWith<_$OnzeContent> get copyWith =>
      __$$OnzeContentCopyWithImpl<_$OnzeContent>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return success(affichage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return success?.call(affichage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(affichage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnzeNotInit value) notInit,
    required TResult Function(OnzeLoading value) loading,
    required TResult Function(OnzeContent value) success,
    required TResult Function(OnzeError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(OnzeNotInit value)? notInit,
    TResult Function(OnzeLoading value)? loading,
    TResult Function(OnzeContent value)? success,
    TResult Function(OnzeError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnzeNotInit value)? notInit,
    TResult Function(OnzeLoading value)? loading,
    TResult Function(OnzeContent value)? success,
    TResult Function(OnzeError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class OnzeContent implements Onze {
  const factory OnzeContent(final Affichage affichage) = _$OnzeContent;

  Affichage get affichage;
  @JsonKey(ignore: true)
  _$$OnzeContentCopyWith<_$OnzeContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OnzeErrorCopyWith<$Res> {
  factory _$$OnzeErrorCopyWith(
          _$OnzeError value, $Res Function(_$OnzeError) then) =
      __$$OnzeErrorCopyWithImpl<$Res>;
  $Res call({String message});
}

/// @nodoc
class __$$OnzeErrorCopyWithImpl<$Res> extends _$OnzeCopyWithImpl<$Res>
    implements _$$OnzeErrorCopyWith<$Res> {
  __$$OnzeErrorCopyWithImpl(
      _$OnzeError _value, $Res Function(_$OnzeError) _then)
      : super(_value, (v) => _then(v as _$OnzeError));

  @override
  _$OnzeError get _value => super._value as _$OnzeError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$OnzeError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$OnzeError implements OnzeError {
  const _$OnzeError(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Onze.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnzeError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$$OnzeErrorCopyWith<_$OnzeError> get copyWith =>
      __$$OnzeErrorCopyWithImpl<_$OnzeError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OnzeNotInit value) notInit,
    required TResult Function(OnzeLoading value) loading,
    required TResult Function(OnzeContent value) success,
    required TResult Function(OnzeError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(OnzeNotInit value)? notInit,
    TResult Function(OnzeLoading value)? loading,
    TResult Function(OnzeContent value)? success,
    TResult Function(OnzeError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OnzeNotInit value)? notInit,
    TResult Function(OnzeLoading value)? loading,
    TResult Function(OnzeContent value)? success,
    TResult Function(OnzeError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class OnzeError implements Onze {
  const factory OnzeError(final String message) = _$OnzeError;

  String get message;
  @JsonKey(ignore: true)
  _$$OnzeErrorCopyWith<_$OnzeError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Douze {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DouzeNotInit value) notInit,
    required TResult Function(DouzeLoading value) loading,
    required TResult Function(DouzeContent value) success,
    required TResult Function(DouzeError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DouzeNotInit value)? notInit,
    TResult Function(DouzeLoading value)? loading,
    TResult Function(DouzeContent value)? success,
    TResult Function(DouzeError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DouzeNotInit value)? notInit,
    TResult Function(DouzeLoading value)? loading,
    TResult Function(DouzeContent value)? success,
    TResult Function(DouzeError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DouzeCopyWith<$Res> {
  factory $DouzeCopyWith(Douze value, $Res Function(Douze) then) =
      _$DouzeCopyWithImpl<$Res>;
}

/// @nodoc
class _$DouzeCopyWithImpl<$Res> implements $DouzeCopyWith<$Res> {
  _$DouzeCopyWithImpl(this._value, this._then);

  final Douze _value;
  // ignore: unused_field
  final $Res Function(Douze) _then;
}

/// @nodoc
abstract class _$$DouzeNotInitCopyWith<$Res> {
  factory _$$DouzeNotInitCopyWith(
          _$DouzeNotInit value, $Res Function(_$DouzeNotInit) then) =
      __$$DouzeNotInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DouzeNotInitCopyWithImpl<$Res> extends _$DouzeCopyWithImpl<$Res>
    implements _$$DouzeNotInitCopyWith<$Res> {
  __$$DouzeNotInitCopyWithImpl(
      _$DouzeNotInit _value, $Res Function(_$DouzeNotInit) _then)
      : super(_value, (v) => _then(v as _$DouzeNotInit));

  @override
  _$DouzeNotInit get _value => super._value as _$DouzeNotInit;
}

/// @nodoc

class _$DouzeNotInit implements DouzeNotInit {
  const _$DouzeNotInit();

  @override
  String toString() {
    return 'Douze.notInit()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DouzeNotInit);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return notInit();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return notInit?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (notInit != null) {
      return notInit();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DouzeNotInit value) notInit,
    required TResult Function(DouzeLoading value) loading,
    required TResult Function(DouzeContent value) success,
    required TResult Function(DouzeError value) error,
  }) {
    return notInit(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DouzeNotInit value)? notInit,
    TResult Function(DouzeLoading value)? loading,
    TResult Function(DouzeContent value)? success,
    TResult Function(DouzeError value)? error,
  }) {
    return notInit?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DouzeNotInit value)? notInit,
    TResult Function(DouzeLoading value)? loading,
    TResult Function(DouzeContent value)? success,
    TResult Function(DouzeError value)? error,
    required TResult orElse(),
  }) {
    if (notInit != null) {
      return notInit(this);
    }
    return orElse();
  }
}

abstract class DouzeNotInit implements Douze {
  const factory DouzeNotInit() = _$DouzeNotInit;
}

/// @nodoc
abstract class _$$DouzeLoadingCopyWith<$Res> {
  factory _$$DouzeLoadingCopyWith(
          _$DouzeLoading value, $Res Function(_$DouzeLoading) then) =
      __$$DouzeLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DouzeLoadingCopyWithImpl<$Res> extends _$DouzeCopyWithImpl<$Res>
    implements _$$DouzeLoadingCopyWith<$Res> {
  __$$DouzeLoadingCopyWithImpl(
      _$DouzeLoading _value, $Res Function(_$DouzeLoading) _then)
      : super(_value, (v) => _then(v as _$DouzeLoading));

  @override
  _$DouzeLoading get _value => super._value as _$DouzeLoading;
}

/// @nodoc

class _$DouzeLoading implements DouzeLoading {
  const _$DouzeLoading();

  @override
  String toString() {
    return 'Douze.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DouzeLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DouzeNotInit value) notInit,
    required TResult Function(DouzeLoading value) loading,
    required TResult Function(DouzeContent value) success,
    required TResult Function(DouzeError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DouzeNotInit value)? notInit,
    TResult Function(DouzeLoading value)? loading,
    TResult Function(DouzeContent value)? success,
    TResult Function(DouzeError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DouzeNotInit value)? notInit,
    TResult Function(DouzeLoading value)? loading,
    TResult Function(DouzeContent value)? success,
    TResult Function(DouzeError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class DouzeLoading implements Douze {
  const factory DouzeLoading() = _$DouzeLoading;
}

/// @nodoc
abstract class _$$DouzeContentCopyWith<$Res> {
  factory _$$DouzeContentCopyWith(
          _$DouzeContent value, $Res Function(_$DouzeContent) then) =
      __$$DouzeContentCopyWithImpl<$Res>;
  $Res call({Affichage affichage});

  $AffichageCopyWith<$Res> get affichage;
}

/// @nodoc
class __$$DouzeContentCopyWithImpl<$Res> extends _$DouzeCopyWithImpl<$Res>
    implements _$$DouzeContentCopyWith<$Res> {
  __$$DouzeContentCopyWithImpl(
      _$DouzeContent _value, $Res Function(_$DouzeContent) _then)
      : super(_value, (v) => _then(v as _$DouzeContent));

  @override
  _$DouzeContent get _value => super._value as _$DouzeContent;

  @override
  $Res call({
    Object? affichage = freezed,
  }) {
    return _then(_$DouzeContent(
      affichage == freezed
          ? _value.affichage
          : affichage // ignore: cast_nullable_to_non_nullable
              as Affichage,
    ));
  }

  @override
  $AffichageCopyWith<$Res> get affichage {
    return $AffichageCopyWith<$Res>(_value.affichage, (value) {
      return _then(_value.copyWith(affichage: value));
    });
  }
}

/// @nodoc

class _$DouzeContent implements DouzeContent {
  const _$DouzeContent(this.affichage);

  @override
  final Affichage affichage;

  @override
  String toString() {
    return 'Douze.success(affichage: $affichage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DouzeContent &&
            const DeepCollectionEquality().equals(other.affichage, affichage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(affichage));

  @JsonKey(ignore: true)
  @override
  _$$DouzeContentCopyWith<_$DouzeContent> get copyWith =>
      __$$DouzeContentCopyWithImpl<_$DouzeContent>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return success(affichage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return success?.call(affichage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(affichage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DouzeNotInit value) notInit,
    required TResult Function(DouzeLoading value) loading,
    required TResult Function(DouzeContent value) success,
    required TResult Function(DouzeError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DouzeNotInit value)? notInit,
    TResult Function(DouzeLoading value)? loading,
    TResult Function(DouzeContent value)? success,
    TResult Function(DouzeError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DouzeNotInit value)? notInit,
    TResult Function(DouzeLoading value)? loading,
    TResult Function(DouzeContent value)? success,
    TResult Function(DouzeError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class DouzeContent implements Douze {
  const factory DouzeContent(final Affichage affichage) = _$DouzeContent;

  Affichage get affichage;
  @JsonKey(ignore: true)
  _$$DouzeContentCopyWith<_$DouzeContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DouzeErrorCopyWith<$Res> {
  factory _$$DouzeErrorCopyWith(
          _$DouzeError value, $Res Function(_$DouzeError) then) =
      __$$DouzeErrorCopyWithImpl<$Res>;
  $Res call({String message});
}

/// @nodoc
class __$$DouzeErrorCopyWithImpl<$Res> extends _$DouzeCopyWithImpl<$Res>
    implements _$$DouzeErrorCopyWith<$Res> {
  __$$DouzeErrorCopyWithImpl(
      _$DouzeError _value, $Res Function(_$DouzeError) _then)
      : super(_value, (v) => _then(v as _$DouzeError));

  @override
  _$DouzeError get _value => super._value as _$DouzeError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$DouzeError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$DouzeError implements DouzeError {
  const _$DouzeError(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Douze.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DouzeError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$$DouzeErrorCopyWith<_$DouzeError> get copyWith =>
      __$$DouzeErrorCopyWithImpl<_$DouzeError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DouzeNotInit value) notInit,
    required TResult Function(DouzeLoading value) loading,
    required TResult Function(DouzeContent value) success,
    required TResult Function(DouzeError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(DouzeNotInit value)? notInit,
    TResult Function(DouzeLoading value)? loading,
    TResult Function(DouzeContent value)? success,
    TResult Function(DouzeError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DouzeNotInit value)? notInit,
    TResult Function(DouzeLoading value)? loading,
    TResult Function(DouzeContent value)? success,
    TResult Function(DouzeError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class DouzeError implements Douze {
  const factory DouzeError(final String message) = _$DouzeError;

  String get message;
  @JsonKey(ignore: true)
  _$$DouzeErrorCopyWith<_$DouzeError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Treize {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TreizeNotInit value) notInit,
    required TResult Function(TreizeLoading value) loading,
    required TResult Function(TreizeContent value) success,
    required TResult Function(TreizeError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(TreizeNotInit value)? notInit,
    TResult Function(TreizeLoading value)? loading,
    TResult Function(TreizeContent value)? success,
    TResult Function(TreizeError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TreizeNotInit value)? notInit,
    TResult Function(TreizeLoading value)? loading,
    TResult Function(TreizeContent value)? success,
    TResult Function(TreizeError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TreizeCopyWith<$Res> {
  factory $TreizeCopyWith(Treize value, $Res Function(Treize) then) =
      _$TreizeCopyWithImpl<$Res>;
}

/// @nodoc
class _$TreizeCopyWithImpl<$Res> implements $TreizeCopyWith<$Res> {
  _$TreizeCopyWithImpl(this._value, this._then);

  final Treize _value;
  // ignore: unused_field
  final $Res Function(Treize) _then;
}

/// @nodoc
abstract class _$$TreizeNotInitCopyWith<$Res> {
  factory _$$TreizeNotInitCopyWith(
          _$TreizeNotInit value, $Res Function(_$TreizeNotInit) then) =
      __$$TreizeNotInitCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TreizeNotInitCopyWithImpl<$Res> extends _$TreizeCopyWithImpl<$Res>
    implements _$$TreizeNotInitCopyWith<$Res> {
  __$$TreizeNotInitCopyWithImpl(
      _$TreizeNotInit _value, $Res Function(_$TreizeNotInit) _then)
      : super(_value, (v) => _then(v as _$TreizeNotInit));

  @override
  _$TreizeNotInit get _value => super._value as _$TreizeNotInit;
}

/// @nodoc

class _$TreizeNotInit implements TreizeNotInit {
  const _$TreizeNotInit();

  @override
  String toString() {
    return 'Treize.notInit()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$TreizeNotInit);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return notInit();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return notInit?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (notInit != null) {
      return notInit();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TreizeNotInit value) notInit,
    required TResult Function(TreizeLoading value) loading,
    required TResult Function(TreizeContent value) success,
    required TResult Function(TreizeError value) error,
  }) {
    return notInit(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(TreizeNotInit value)? notInit,
    TResult Function(TreizeLoading value)? loading,
    TResult Function(TreizeContent value)? success,
    TResult Function(TreizeError value)? error,
  }) {
    return notInit?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TreizeNotInit value)? notInit,
    TResult Function(TreizeLoading value)? loading,
    TResult Function(TreizeContent value)? success,
    TResult Function(TreizeError value)? error,
    required TResult orElse(),
  }) {
    if (notInit != null) {
      return notInit(this);
    }
    return orElse();
  }
}

abstract class TreizeNotInit implements Treize {
  const factory TreizeNotInit() = _$TreizeNotInit;
}

/// @nodoc
abstract class _$$TreizeLoadingCopyWith<$Res> {
  factory _$$TreizeLoadingCopyWith(
          _$TreizeLoading value, $Res Function(_$TreizeLoading) then) =
      __$$TreizeLoadingCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TreizeLoadingCopyWithImpl<$Res> extends _$TreizeCopyWithImpl<$Res>
    implements _$$TreizeLoadingCopyWith<$Res> {
  __$$TreizeLoadingCopyWithImpl(
      _$TreizeLoading _value, $Res Function(_$TreizeLoading) _then)
      : super(_value, (v) => _then(v as _$TreizeLoading));

  @override
  _$TreizeLoading get _value => super._value as _$TreizeLoading;
}

/// @nodoc

class _$TreizeLoading implements TreizeLoading {
  const _$TreizeLoading();

  @override
  String toString() {
    return 'Treize.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$TreizeLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TreizeNotInit value) notInit,
    required TResult Function(TreizeLoading value) loading,
    required TResult Function(TreizeContent value) success,
    required TResult Function(TreizeError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(TreizeNotInit value)? notInit,
    TResult Function(TreizeLoading value)? loading,
    TResult Function(TreizeContent value)? success,
    TResult Function(TreizeError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TreizeNotInit value)? notInit,
    TResult Function(TreizeLoading value)? loading,
    TResult Function(TreizeContent value)? success,
    TResult Function(TreizeError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class TreizeLoading implements Treize {
  const factory TreizeLoading() = _$TreizeLoading;
}

/// @nodoc
abstract class _$$TreizeContentCopyWith<$Res> {
  factory _$$TreizeContentCopyWith(
          _$TreizeContent value, $Res Function(_$TreizeContent) then) =
      __$$TreizeContentCopyWithImpl<$Res>;
  $Res call({Affichage affichage});

  $AffichageCopyWith<$Res> get affichage;
}

/// @nodoc
class __$$TreizeContentCopyWithImpl<$Res> extends _$TreizeCopyWithImpl<$Res>
    implements _$$TreizeContentCopyWith<$Res> {
  __$$TreizeContentCopyWithImpl(
      _$TreizeContent _value, $Res Function(_$TreizeContent) _then)
      : super(_value, (v) => _then(v as _$TreizeContent));

  @override
  _$TreizeContent get _value => super._value as _$TreizeContent;

  @override
  $Res call({
    Object? affichage = freezed,
  }) {
    return _then(_$TreizeContent(
      affichage == freezed
          ? _value.affichage
          : affichage // ignore: cast_nullable_to_non_nullable
              as Affichage,
    ));
  }

  @override
  $AffichageCopyWith<$Res> get affichage {
    return $AffichageCopyWith<$Res>(_value.affichage, (value) {
      return _then(_value.copyWith(affichage: value));
    });
  }
}

/// @nodoc

class _$TreizeContent implements TreizeContent {
  const _$TreizeContent(this.affichage);

  @override
  final Affichage affichage;

  @override
  String toString() {
    return 'Treize.success(affichage: $affichage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TreizeContent &&
            const DeepCollectionEquality().equals(other.affichage, affichage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(affichage));

  @JsonKey(ignore: true)
  @override
  _$$TreizeContentCopyWith<_$TreizeContent> get copyWith =>
      __$$TreizeContentCopyWithImpl<_$TreizeContent>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return success(affichage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return success?.call(affichage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(affichage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TreizeNotInit value) notInit,
    required TResult Function(TreizeLoading value) loading,
    required TResult Function(TreizeContent value) success,
    required TResult Function(TreizeError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(TreizeNotInit value)? notInit,
    TResult Function(TreizeLoading value)? loading,
    TResult Function(TreizeContent value)? success,
    TResult Function(TreizeError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TreizeNotInit value)? notInit,
    TResult Function(TreizeLoading value)? loading,
    TResult Function(TreizeContent value)? success,
    TResult Function(TreizeError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class TreizeContent implements Treize {
  const factory TreizeContent(final Affichage affichage) = _$TreizeContent;

  Affichage get affichage;
  @JsonKey(ignore: true)
  _$$TreizeContentCopyWith<_$TreizeContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TreizeErrorCopyWith<$Res> {
  factory _$$TreizeErrorCopyWith(
          _$TreizeError value, $Res Function(_$TreizeError) then) =
      __$$TreizeErrorCopyWithImpl<$Res>;
  $Res call({String message});
}

/// @nodoc
class __$$TreizeErrorCopyWithImpl<$Res> extends _$TreizeCopyWithImpl<$Res>
    implements _$$TreizeErrorCopyWith<$Res> {
  __$$TreizeErrorCopyWithImpl(
      _$TreizeError _value, $Res Function(_$TreizeError) _then)
      : super(_value, (v) => _then(v as _$TreizeError));

  @override
  _$TreizeError get _value => super._value as _$TreizeError;

  @override
  $Res call({
    Object? message = freezed,
  }) {
    return _then(_$TreizeError(
      message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$TreizeError implements TreizeError {
  const _$TreizeError(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Treize.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TreizeError &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$$TreizeErrorCopyWith<_$TreizeError> get copyWith =>
      __$$TreizeErrorCopyWithImpl<_$TreizeError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() notInit,
    required TResult Function() loading,
    required TResult Function(Affichage affichage) success,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? notInit,
    TResult Function()? loading,
    TResult Function(Affichage affichage)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TreizeNotInit value) notInit,
    required TResult Function(TreizeLoading value) loading,
    required TResult Function(TreizeContent value) success,
    required TResult Function(TreizeError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(TreizeNotInit value)? notInit,
    TResult Function(TreizeLoading value)? loading,
    TResult Function(TreizeContent value)? success,
    TResult Function(TreizeError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TreizeNotInit value)? notInit,
    TResult Function(TreizeLoading value)? loading,
    TResult Function(TreizeContent value)? success,
    TResult Function(TreizeError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class TreizeError implements Treize {
  const factory TreizeError(final String message) = _$TreizeError;

  String get message;
  @JsonKey(ignore: true)
  _$$TreizeErrorCopyWith<_$TreizeError> get copyWith =>
      throw _privateConstructorUsedError;
}
