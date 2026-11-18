// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'generation_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GenerationRequest {

 Situation get situation; MessageStyle get style;/// Message reçu ; utilisé seulement si la situation l'exige.
 String? get message;/// Précisions facultatives de l'utilisateur sur la situation.
 String? get context;/// Capture de la conversation, à la place du message reçu (INTAKE §2.2).
 Uint8List? get screenshot;
/// Create a copy of GenerationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenerationRequestCopyWith<GenerationRequest> get copyWith => _$GenerationRequestCopyWithImpl<GenerationRequest>(this as GenerationRequest, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenerationRequest&&(identical(other.situation, situation) || other.situation == situation)&&(identical(other.style, style) || other.style == style)&&(identical(other.message, message) || other.message == message)&&(identical(other.context, context) || other.context == context)&&const DeepCollectionEquality().equals(other.screenshot, screenshot));
}


@override
int get hashCode => Object.hash(runtimeType,situation,style,message,context,const DeepCollectionEquality().hash(screenshot));

@override
String toString() {
  return 'GenerationRequest(situation: $situation, style: $style, message: $message, context: $context, screenshot: $screenshot)';
}


}

/// @nodoc
abstract mixin class $GenerationRequestCopyWith<$Res>  {
  factory $GenerationRequestCopyWith(GenerationRequest value, $Res Function(GenerationRequest) _then) = _$GenerationRequestCopyWithImpl;
@useResult
$Res call({
 Situation situation, MessageStyle style, String? message, String? context, Uint8List? screenshot
});




}
/// @nodoc
class _$GenerationRequestCopyWithImpl<$Res>
    implements $GenerationRequestCopyWith<$Res> {
  _$GenerationRequestCopyWithImpl(this._self, this._then);

  final GenerationRequest _self;
  final $Res Function(GenerationRequest) _then;

/// Create a copy of GenerationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? situation = null,Object? style = null,Object? message = freezed,Object? context = freezed,Object? screenshot = freezed,}) {
  return _then(_self.copyWith(
situation: null == situation ? _self.situation : situation // ignore: cast_nullable_to_non_nullable
as Situation,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as MessageStyle,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,context: freezed == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as String?,screenshot: freezed == screenshot ? _self.screenshot : screenshot // ignore: cast_nullable_to_non_nullable
as Uint8List?,
  ));
}

}


/// Adds pattern-matching-related methods to [GenerationRequest].
extension GenerationRequestPatterns on GenerationRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GenerationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GenerationRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GenerationRequest value)  $default,){
final _that = this;
switch (_that) {
case _GenerationRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GenerationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _GenerationRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Situation situation,  MessageStyle style,  String? message,  String? context,  Uint8List? screenshot)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GenerationRequest() when $default != null:
return $default(_that.situation,_that.style,_that.message,_that.context,_that.screenshot);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Situation situation,  MessageStyle style,  String? message,  String? context,  Uint8List? screenshot)  $default,) {final _that = this;
switch (_that) {
case _GenerationRequest():
return $default(_that.situation,_that.style,_that.message,_that.context,_that.screenshot);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Situation situation,  MessageStyle style,  String? message,  String? context,  Uint8List? screenshot)?  $default,) {final _that = this;
switch (_that) {
case _GenerationRequest() when $default != null:
return $default(_that.situation,_that.style,_that.message,_that.context,_that.screenshot);case _:
  return null;

}
}

}

/// @nodoc


class _GenerationRequest extends GenerationRequest {
  const _GenerationRequest({required this.situation, required this.style, this.message, this.context, this.screenshot}): super._();
  

@override final  Situation situation;
@override final  MessageStyle style;
/// Message reçu ; utilisé seulement si la situation l'exige.
@override final  String? message;
/// Précisions facultatives de l'utilisateur sur la situation.
@override final  String? context;
/// Capture de la conversation, à la place du message reçu (INTAKE §2.2).
@override final  Uint8List? screenshot;

/// Create a copy of GenerationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenerationRequestCopyWith<_GenerationRequest> get copyWith => __$GenerationRequestCopyWithImpl<_GenerationRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenerationRequest&&(identical(other.situation, situation) || other.situation == situation)&&(identical(other.style, style) || other.style == style)&&(identical(other.message, message) || other.message == message)&&(identical(other.context, context) || other.context == context)&&const DeepCollectionEquality().equals(other.screenshot, screenshot));
}


@override
int get hashCode => Object.hash(runtimeType,situation,style,message,context,const DeepCollectionEquality().hash(screenshot));

@override
String toString() {
  return 'GenerationRequest(situation: $situation, style: $style, message: $message, context: $context, screenshot: $screenshot)';
}


}

/// @nodoc
abstract mixin class _$GenerationRequestCopyWith<$Res> implements $GenerationRequestCopyWith<$Res> {
  factory _$GenerationRequestCopyWith(_GenerationRequest value, $Res Function(_GenerationRequest) _then) = __$GenerationRequestCopyWithImpl;
@override @useResult
$Res call({
 Situation situation, MessageStyle style, String? message, String? context, Uint8List? screenshot
});




}
/// @nodoc
class __$GenerationRequestCopyWithImpl<$Res>
    implements _$GenerationRequestCopyWith<$Res> {
  __$GenerationRequestCopyWithImpl(this._self, this._then);

  final _GenerationRequest _self;
  final $Res Function(_GenerationRequest) _then;

/// Create a copy of GenerationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? situation = null,Object? style = null,Object? message = freezed,Object? context = freezed,Object? screenshot = freezed,}) {
  return _then(_GenerationRequest(
situation: null == situation ? _self.situation : situation // ignore: cast_nullable_to_non_nullable
as Situation,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as MessageStyle,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,context: freezed == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as String?,screenshot: freezed == screenshot ? _self.screenshot : screenshot // ignore: cast_nullable_to_non_nullable
as Uint8List?,
  ));
}


}

// dart format on
