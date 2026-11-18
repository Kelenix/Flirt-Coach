// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'respect_check.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RespectIssue {

 RespectIssueCategory get category; String get explanation;
/// Create a copy of RespectIssue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RespectIssueCopyWith<RespectIssue> get copyWith => _$RespectIssueCopyWithImpl<RespectIssue>(this as RespectIssue, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RespectIssue&&(identical(other.category, category) || other.category == category)&&(identical(other.explanation, explanation) || other.explanation == explanation));
}


@override
int get hashCode => Object.hash(runtimeType,category,explanation);

@override
String toString() {
  return 'RespectIssue(category: $category, explanation: $explanation)';
}


}

/// @nodoc
abstract mixin class $RespectIssueCopyWith<$Res>  {
  factory $RespectIssueCopyWith(RespectIssue value, $Res Function(RespectIssue) _then) = _$RespectIssueCopyWithImpl;
@useResult
$Res call({
 RespectIssueCategory category, String explanation
});




}
/// @nodoc
class _$RespectIssueCopyWithImpl<$Res>
    implements $RespectIssueCopyWith<$Res> {
  _$RespectIssueCopyWithImpl(this._self, this._then);

  final RespectIssue _self;
  final $Res Function(RespectIssue) _then;

/// Create a copy of RespectIssue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? explanation = null,}) {
  return _then(_self.copyWith(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as RespectIssueCategory,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RespectIssue].
extension RespectIssuePatterns on RespectIssue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RespectIssue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RespectIssue() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RespectIssue value)  $default,){
final _that = this;
switch (_that) {
case _RespectIssue():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RespectIssue value)?  $default,){
final _that = this;
switch (_that) {
case _RespectIssue() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RespectIssueCategory category,  String explanation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RespectIssue() when $default != null:
return $default(_that.category,_that.explanation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RespectIssueCategory category,  String explanation)  $default,) {final _that = this;
switch (_that) {
case _RespectIssue():
return $default(_that.category,_that.explanation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RespectIssueCategory category,  String explanation)?  $default,) {final _that = this;
switch (_that) {
case _RespectIssue() when $default != null:
return $default(_that.category,_that.explanation);case _:
  return null;

}
}

}

/// @nodoc


class _RespectIssue implements RespectIssue {
  const _RespectIssue({required this.category, required this.explanation});
  

@override final  RespectIssueCategory category;
@override final  String explanation;

/// Create a copy of RespectIssue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RespectIssueCopyWith<_RespectIssue> get copyWith => __$RespectIssueCopyWithImpl<_RespectIssue>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RespectIssue&&(identical(other.category, category) || other.category == category)&&(identical(other.explanation, explanation) || other.explanation == explanation));
}


@override
int get hashCode => Object.hash(runtimeType,category,explanation);

@override
String toString() {
  return 'RespectIssue(category: $category, explanation: $explanation)';
}


}

/// @nodoc
abstract mixin class _$RespectIssueCopyWith<$Res> implements $RespectIssueCopyWith<$Res> {
  factory _$RespectIssueCopyWith(_RespectIssue value, $Res Function(_RespectIssue) _then) = __$RespectIssueCopyWithImpl;
@override @useResult
$Res call({
 RespectIssueCategory category, String explanation
});




}
/// @nodoc
class __$RespectIssueCopyWithImpl<$Res>
    implements _$RespectIssueCopyWith<$Res> {
  __$RespectIssueCopyWithImpl(this._self, this._then);

  final _RespectIssue _self;
  final $Res Function(_RespectIssue) _then;

/// Create a copy of RespectIssue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? explanation = null,}) {
  return _then(_RespectIssue(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as RespectIssueCategory,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$RespectCheck {

 Wallet get wallet;
/// Create a copy of RespectCheck
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RespectCheckCopyWith<RespectCheck> get copyWith => _$RespectCheckCopyWithImpl<RespectCheck>(this as RespectCheck, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RespectCheck&&(identical(other.wallet, wallet) || other.wallet == wallet));
}


@override
int get hashCode => Object.hash(runtimeType,wallet);

@override
String toString() {
  return 'RespectCheck(wallet: $wallet)';
}


}

/// @nodoc
abstract mixin class $RespectCheckCopyWith<$Res>  {
  factory $RespectCheckCopyWith(RespectCheck value, $Res Function(RespectCheck) _then) = _$RespectCheckCopyWithImpl;
@useResult
$Res call({
 Wallet wallet
});


$WalletCopyWith<$Res> get wallet;

}
/// @nodoc
class _$RespectCheckCopyWithImpl<$Res>
    implements $RespectCheckCopyWith<$Res> {
  _$RespectCheckCopyWithImpl(this._self, this._then);

  final RespectCheck _self;
  final $Res Function(RespectCheck) _then;

/// Create a copy of RespectCheck
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? wallet = null,}) {
  return _then(_self.copyWith(
wallet: null == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as Wallet,
  ));
}
/// Create a copy of RespectCheck
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletCopyWith<$Res> get wallet {
  
  return $WalletCopyWith<$Res>(_self.wallet, (value) {
    return _then(_self.copyWith(wallet: value));
  });
}
}


/// Adds pattern-matching-related methods to [RespectCheck].
extension RespectCheckPatterns on RespectCheck {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RespectVerdict value)?  verdict,TResult Function( RespectRefused value)?  refused,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RespectVerdict() when verdict != null:
return verdict(_that);case RespectRefused() when refused != null:
return refused(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RespectVerdict value)  verdict,required TResult Function( RespectRefused value)  refused,}){
final _that = this;
switch (_that) {
case RespectVerdict():
return verdict(_that);case RespectRefused():
return refused(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RespectVerdict value)?  verdict,TResult? Function( RespectRefused value)?  refused,}){
final _that = this;
switch (_that) {
case RespectVerdict() when verdict != null:
return verdict(_that);case RespectRefused() when refused != null:
return refused(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<RespectIssue> issues,  String? alternative,  Wallet wallet)?  verdict,TResult Function( String reason,  Wallet wallet)?  refused,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RespectVerdict() when verdict != null:
return verdict(_that.issues,_that.alternative,_that.wallet);case RespectRefused() when refused != null:
return refused(_that.reason,_that.wallet);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<RespectIssue> issues,  String? alternative,  Wallet wallet)  verdict,required TResult Function( String reason,  Wallet wallet)  refused,}) {final _that = this;
switch (_that) {
case RespectVerdict():
return verdict(_that.issues,_that.alternative,_that.wallet);case RespectRefused():
return refused(_that.reason,_that.wallet);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<RespectIssue> issues,  String? alternative,  Wallet wallet)?  verdict,TResult? Function( String reason,  Wallet wallet)?  refused,}) {final _that = this;
switch (_that) {
case RespectVerdict() when verdict != null:
return verdict(_that.issues,_that.alternative,_that.wallet);case RespectRefused() when refused != null:
return refused(_that.reason,_that.wallet);case _:
  return null;

}
}

}

/// @nodoc


class RespectVerdict extends RespectCheck {
  const RespectVerdict({required final  List<RespectIssue> issues, required this.alternative, required this.wallet}): _issues = issues,super._();
  

 final  List<RespectIssue> _issues;
 List<RespectIssue> get issues {
  if (_issues is EqualUnmodifiableListView) return _issues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_issues);
}

 final  String? alternative;
@override final  Wallet wallet;

/// Create a copy of RespectCheck
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RespectVerdictCopyWith<RespectVerdict> get copyWith => _$RespectVerdictCopyWithImpl<RespectVerdict>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RespectVerdict&&const DeepCollectionEquality().equals(other._issues, _issues)&&(identical(other.alternative, alternative) || other.alternative == alternative)&&(identical(other.wallet, wallet) || other.wallet == wallet));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_issues),alternative,wallet);

@override
String toString() {
  return 'RespectCheck.verdict(issues: $issues, alternative: $alternative, wallet: $wallet)';
}


}

/// @nodoc
abstract mixin class $RespectVerdictCopyWith<$Res> implements $RespectCheckCopyWith<$Res> {
  factory $RespectVerdictCopyWith(RespectVerdict value, $Res Function(RespectVerdict) _then) = _$RespectVerdictCopyWithImpl;
@override @useResult
$Res call({
 List<RespectIssue> issues, String? alternative, Wallet wallet
});


@override $WalletCopyWith<$Res> get wallet;

}
/// @nodoc
class _$RespectVerdictCopyWithImpl<$Res>
    implements $RespectVerdictCopyWith<$Res> {
  _$RespectVerdictCopyWithImpl(this._self, this._then);

  final RespectVerdict _self;
  final $Res Function(RespectVerdict) _then;

/// Create a copy of RespectCheck
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? issues = null,Object? alternative = freezed,Object? wallet = null,}) {
  return _then(RespectVerdict(
issues: null == issues ? _self._issues : issues // ignore: cast_nullable_to_non_nullable
as List<RespectIssue>,alternative: freezed == alternative ? _self.alternative : alternative // ignore: cast_nullable_to_non_nullable
as String?,wallet: null == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as Wallet,
  ));
}

/// Create a copy of RespectCheck
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletCopyWith<$Res> get wallet {
  
  return $WalletCopyWith<$Res>(_self.wallet, (value) {
    return _then(_self.copyWith(wallet: value));
  });
}
}

/// @nodoc


class RespectRefused extends RespectCheck {
  const RespectRefused({required this.reason, required this.wallet}): super._();
  

 final  String reason;
@override final  Wallet wallet;

/// Create a copy of RespectCheck
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RespectRefusedCopyWith<RespectRefused> get copyWith => _$RespectRefusedCopyWithImpl<RespectRefused>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RespectRefused&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.wallet, wallet) || other.wallet == wallet));
}


@override
int get hashCode => Object.hash(runtimeType,reason,wallet);

@override
String toString() {
  return 'RespectCheck.refused(reason: $reason, wallet: $wallet)';
}


}

/// @nodoc
abstract mixin class $RespectRefusedCopyWith<$Res> implements $RespectCheckCopyWith<$Res> {
  factory $RespectRefusedCopyWith(RespectRefused value, $Res Function(RespectRefused) _then) = _$RespectRefusedCopyWithImpl;
@override @useResult
$Res call({
 String reason, Wallet wallet
});


@override $WalletCopyWith<$Res> get wallet;

}
/// @nodoc
class _$RespectRefusedCopyWithImpl<$Res>
    implements $RespectRefusedCopyWith<$Res> {
  _$RespectRefusedCopyWithImpl(this._self, this._then);

  final RespectRefused _self;
  final $Res Function(RespectRefused) _then;

/// Create a copy of RespectCheck
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reason = null,Object? wallet = null,}) {
  return _then(RespectRefused(
reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,wallet: null == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as Wallet,
  ));
}

/// Create a copy of RespectCheck
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletCopyWith<$Res> get wallet {
  
  return $WalletCopyWith<$Res>(_self.wallet, (value) {
    return _then(_self.copyWith(wallet: value));
  });
}
}

// dart format on
