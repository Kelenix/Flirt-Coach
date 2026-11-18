// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'generation_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GenerationResult {

 Wallet get wallet;
/// Create a copy of GenerationResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenerationResultCopyWith<GenerationResult> get copyWith => _$GenerationResultCopyWithImpl<GenerationResult>(this as GenerationResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenerationResult&&(identical(other.wallet, wallet) || other.wallet == wallet));
}


@override
int get hashCode => Object.hash(runtimeType,wallet);

@override
String toString() {
  return 'GenerationResult(wallet: $wallet)';
}


}

/// @nodoc
abstract mixin class $GenerationResultCopyWith<$Res>  {
  factory $GenerationResultCopyWith(GenerationResult value, $Res Function(GenerationResult) _then) = _$GenerationResultCopyWithImpl;
@useResult
$Res call({
 Wallet wallet
});


$WalletCopyWith<$Res> get wallet;

}
/// @nodoc
class _$GenerationResultCopyWithImpl<$Res>
    implements $GenerationResultCopyWith<$Res> {
  _$GenerationResultCopyWithImpl(this._self, this._then);

  final GenerationResult _self;
  final $Res Function(GenerationResult) _then;

/// Create a copy of GenerationResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? wallet = null,}) {
  return _then(_self.copyWith(
wallet: null == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as Wallet,
  ));
}
/// Create a copy of GenerationResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletCopyWith<$Res> get wallet {
  
  return $WalletCopyWith<$Res>(_self.wallet, (value) {
    return _then(_self.copyWith(wallet: value));
  });
}
}


/// Adds pattern-matching-related methods to [GenerationResult].
extension GenerationResultPatterns on GenerationResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( GeneratedProposals value)?  proposals,TResult Function( RefusedGeneration value)?  refused,required TResult orElse(),}){
final _that = this;
switch (_that) {
case GeneratedProposals() when proposals != null:
return proposals(_that);case RefusedGeneration() when refused != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( GeneratedProposals value)  proposals,required TResult Function( RefusedGeneration value)  refused,}){
final _that = this;
switch (_that) {
case GeneratedProposals():
return proposals(_that);case RefusedGeneration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( GeneratedProposals value)?  proposals,TResult? Function( RefusedGeneration value)?  refused,}){
final _that = this;
switch (_that) {
case GeneratedProposals() when proposals != null:
return proposals(_that);case RefusedGeneration() when refused != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String id,  List<String> proposals,  Wallet wallet)?  proposals,TResult Function( String reason,  Wallet wallet)?  refused,required TResult orElse(),}) {final _that = this;
switch (_that) {
case GeneratedProposals() when proposals != null:
return proposals(_that.id,_that.proposals,_that.wallet);case RefusedGeneration() when refused != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String id,  List<String> proposals,  Wallet wallet)  proposals,required TResult Function( String reason,  Wallet wallet)  refused,}) {final _that = this;
switch (_that) {
case GeneratedProposals():
return proposals(_that.id,_that.proposals,_that.wallet);case RefusedGeneration():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String id,  List<String> proposals,  Wallet wallet)?  proposals,TResult? Function( String reason,  Wallet wallet)?  refused,}) {final _that = this;
switch (_that) {
case GeneratedProposals() when proposals != null:
return proposals(_that.id,_that.proposals,_that.wallet);case RefusedGeneration() when refused != null:
return refused(_that.reason,_that.wallet);case _:
  return null;

}
}

}

/// @nodoc


class GeneratedProposals implements GenerationResult {
  const GeneratedProposals({required this.id, required final  List<String> proposals, required this.wallet}): _proposals = proposals;
  

 final  String id;
 final  List<String> _proposals;
 List<String> get proposals {
  if (_proposals is EqualUnmodifiableListView) return _proposals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_proposals);
}

@override final  Wallet wallet;

/// Create a copy of GenerationResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeneratedProposalsCopyWith<GeneratedProposals> get copyWith => _$GeneratedProposalsCopyWithImpl<GeneratedProposals>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeneratedProposals&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._proposals, _proposals)&&(identical(other.wallet, wallet) || other.wallet == wallet));
}


@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_proposals),wallet);

@override
String toString() {
  return 'GenerationResult.proposals(id: $id, proposals: $proposals, wallet: $wallet)';
}


}

/// @nodoc
abstract mixin class $GeneratedProposalsCopyWith<$Res> implements $GenerationResultCopyWith<$Res> {
  factory $GeneratedProposalsCopyWith(GeneratedProposals value, $Res Function(GeneratedProposals) _then) = _$GeneratedProposalsCopyWithImpl;
@override @useResult
$Res call({
 String id, List<String> proposals, Wallet wallet
});


@override $WalletCopyWith<$Res> get wallet;

}
/// @nodoc
class _$GeneratedProposalsCopyWithImpl<$Res>
    implements $GeneratedProposalsCopyWith<$Res> {
  _$GeneratedProposalsCopyWithImpl(this._self, this._then);

  final GeneratedProposals _self;
  final $Res Function(GeneratedProposals) _then;

/// Create a copy of GenerationResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? proposals = null,Object? wallet = null,}) {
  return _then(GeneratedProposals(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,proposals: null == proposals ? _self._proposals : proposals // ignore: cast_nullable_to_non_nullable
as List<String>,wallet: null == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as Wallet,
  ));
}

/// Create a copy of GenerationResult
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


class RefusedGeneration implements GenerationResult {
  const RefusedGeneration({required this.reason, required this.wallet});
  

 final  String reason;
@override final  Wallet wallet;

/// Create a copy of GenerationResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RefusedGenerationCopyWith<RefusedGeneration> get copyWith => _$RefusedGenerationCopyWithImpl<RefusedGeneration>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefusedGeneration&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.wallet, wallet) || other.wallet == wallet));
}


@override
int get hashCode => Object.hash(runtimeType,reason,wallet);

@override
String toString() {
  return 'GenerationResult.refused(reason: $reason, wallet: $wallet)';
}


}

/// @nodoc
abstract mixin class $RefusedGenerationCopyWith<$Res> implements $GenerationResultCopyWith<$Res> {
  factory $RefusedGenerationCopyWith(RefusedGeneration value, $Res Function(RefusedGeneration) _then) = _$RefusedGenerationCopyWithImpl;
@override @useResult
$Res call({
 String reason, Wallet wallet
});


@override $WalletCopyWith<$Res> get wallet;

}
/// @nodoc
class _$RefusedGenerationCopyWithImpl<$Res>
    implements $RefusedGenerationCopyWith<$Res> {
  _$RefusedGenerationCopyWithImpl(this._self, this._then);

  final RefusedGeneration _self;
  final $Res Function(RefusedGeneration) _then;

/// Create a copy of GenerationResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reason = null,Object? wallet = null,}) {
  return _then(RefusedGeneration(
reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,wallet: null == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as Wallet,
  ));
}

/// Create a copy of GenerationResult
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
