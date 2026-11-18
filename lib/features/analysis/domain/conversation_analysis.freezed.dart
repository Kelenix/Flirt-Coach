// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_analysis.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConversationAnalysis {

 Wallet get wallet;
/// Create a copy of ConversationAnalysis
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationAnalysisCopyWith<ConversationAnalysis> get copyWith => _$ConversationAnalysisCopyWithImpl<ConversationAnalysis>(this as ConversationAnalysis, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationAnalysis&&(identical(other.wallet, wallet) || other.wallet == wallet));
}


@override
int get hashCode => Object.hash(runtimeType,wallet);

@override
String toString() {
  return 'ConversationAnalysis(wallet: $wallet)';
}


}

/// @nodoc
abstract mixin class $ConversationAnalysisCopyWith<$Res>  {
  factory $ConversationAnalysisCopyWith(ConversationAnalysis value, $Res Function(ConversationAnalysis) _then) = _$ConversationAnalysisCopyWithImpl;
@useResult
$Res call({
 Wallet wallet
});


$WalletCopyWith<$Res> get wallet;

}
/// @nodoc
class _$ConversationAnalysisCopyWithImpl<$Res>
    implements $ConversationAnalysisCopyWith<$Res> {
  _$ConversationAnalysisCopyWithImpl(this._self, this._then);

  final ConversationAnalysis _self;
  final $Res Function(ConversationAnalysis) _then;

/// Create a copy of ConversationAnalysis
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? wallet = null,}) {
  return _then(_self.copyWith(
wallet: null == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as Wallet,
  ));
}
/// Create a copy of ConversationAnalysis
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletCopyWith<$Res> get wallet {
  
  return $WalletCopyWith<$Res>(_self.wallet, (value) {
    return _then(_self.copyWith(wallet: value));
  });
}
}


/// Adds pattern-matching-related methods to [ConversationAnalysis].
extension ConversationAnalysisPatterns on ConversationAnalysis {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AnalysisResult value)?  result,TResult Function( AnalysisRefused value)?  refused,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AnalysisResult() when result != null:
return result(_that);case AnalysisRefused() when refused != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AnalysisResult value)  result,required TResult Function( AnalysisRefused value)  refused,}){
final _that = this;
switch (_that) {
case AnalysisResult():
return result(_that);case AnalysisRefused():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AnalysisResult value)?  result,TResult? Function( AnalysisRefused value)?  refused,}){
final _that = this;
switch (_that) {
case AnalysisResult() when result != null:
return result(_that);case AnalysisRefused() when refused != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Momentum momentum,  String summary,  String nextStep,  String suggestedMessage,  String? dateSuggestion,  Wallet wallet)?  result,TResult Function( String reason,  Wallet wallet)?  refused,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AnalysisResult() when result != null:
return result(_that.momentum,_that.summary,_that.nextStep,_that.suggestedMessage,_that.dateSuggestion,_that.wallet);case AnalysisRefused() when refused != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Momentum momentum,  String summary,  String nextStep,  String suggestedMessage,  String? dateSuggestion,  Wallet wallet)  result,required TResult Function( String reason,  Wallet wallet)  refused,}) {final _that = this;
switch (_that) {
case AnalysisResult():
return result(_that.momentum,_that.summary,_that.nextStep,_that.suggestedMessage,_that.dateSuggestion,_that.wallet);case AnalysisRefused():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Momentum momentum,  String summary,  String nextStep,  String suggestedMessage,  String? dateSuggestion,  Wallet wallet)?  result,TResult? Function( String reason,  Wallet wallet)?  refused,}) {final _that = this;
switch (_that) {
case AnalysisResult() when result != null:
return result(_that.momentum,_that.summary,_that.nextStep,_that.suggestedMessage,_that.dateSuggestion,_that.wallet);case AnalysisRefused() when refused != null:
return refused(_that.reason,_that.wallet);case _:
  return null;

}
}

}

/// @nodoc


class AnalysisResult implements ConversationAnalysis {
  const AnalysisResult({required this.momentum, required this.summary, required this.nextStep, required this.suggestedMessage, required this.dateSuggestion, required this.wallet});
  

 final  Momentum momentum;
 final  String summary;
 final  String nextStep;
 final  String suggestedMessage;
 final  String? dateSuggestion;
@override final  Wallet wallet;

/// Create a copy of ConversationAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalysisResultCopyWith<AnalysisResult> get copyWith => _$AnalysisResultCopyWithImpl<AnalysisResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalysisResult&&(identical(other.momentum, momentum) || other.momentum == momentum)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.nextStep, nextStep) || other.nextStep == nextStep)&&(identical(other.suggestedMessage, suggestedMessage) || other.suggestedMessage == suggestedMessage)&&(identical(other.dateSuggestion, dateSuggestion) || other.dateSuggestion == dateSuggestion)&&(identical(other.wallet, wallet) || other.wallet == wallet));
}


@override
int get hashCode => Object.hash(runtimeType,momentum,summary,nextStep,suggestedMessage,dateSuggestion,wallet);

@override
String toString() {
  return 'ConversationAnalysis.result(momentum: $momentum, summary: $summary, nextStep: $nextStep, suggestedMessage: $suggestedMessage, dateSuggestion: $dateSuggestion, wallet: $wallet)';
}


}

/// @nodoc
abstract mixin class $AnalysisResultCopyWith<$Res> implements $ConversationAnalysisCopyWith<$Res> {
  factory $AnalysisResultCopyWith(AnalysisResult value, $Res Function(AnalysisResult) _then) = _$AnalysisResultCopyWithImpl;
@override @useResult
$Res call({
 Momentum momentum, String summary, String nextStep, String suggestedMessage, String? dateSuggestion, Wallet wallet
});


@override $WalletCopyWith<$Res> get wallet;

}
/// @nodoc
class _$AnalysisResultCopyWithImpl<$Res>
    implements $AnalysisResultCopyWith<$Res> {
  _$AnalysisResultCopyWithImpl(this._self, this._then);

  final AnalysisResult _self;
  final $Res Function(AnalysisResult) _then;

/// Create a copy of ConversationAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? momentum = null,Object? summary = null,Object? nextStep = null,Object? suggestedMessage = null,Object? dateSuggestion = freezed,Object? wallet = null,}) {
  return _then(AnalysisResult(
momentum: null == momentum ? _self.momentum : momentum // ignore: cast_nullable_to_non_nullable
as Momentum,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,nextStep: null == nextStep ? _self.nextStep : nextStep // ignore: cast_nullable_to_non_nullable
as String,suggestedMessage: null == suggestedMessage ? _self.suggestedMessage : suggestedMessage // ignore: cast_nullable_to_non_nullable
as String,dateSuggestion: freezed == dateSuggestion ? _self.dateSuggestion : dateSuggestion // ignore: cast_nullable_to_non_nullable
as String?,wallet: null == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as Wallet,
  ));
}

/// Create a copy of ConversationAnalysis
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


class AnalysisRefused implements ConversationAnalysis {
  const AnalysisRefused({required this.reason, required this.wallet});
  

 final  String reason;
@override final  Wallet wallet;

/// Create a copy of ConversationAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalysisRefusedCopyWith<AnalysisRefused> get copyWith => _$AnalysisRefusedCopyWithImpl<AnalysisRefused>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalysisRefused&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.wallet, wallet) || other.wallet == wallet));
}


@override
int get hashCode => Object.hash(runtimeType,reason,wallet);

@override
String toString() {
  return 'ConversationAnalysis.refused(reason: $reason, wallet: $wallet)';
}


}

/// @nodoc
abstract mixin class $AnalysisRefusedCopyWith<$Res> implements $ConversationAnalysisCopyWith<$Res> {
  factory $AnalysisRefusedCopyWith(AnalysisRefused value, $Res Function(AnalysisRefused) _then) = _$AnalysisRefusedCopyWithImpl;
@override @useResult
$Res call({
 String reason, Wallet wallet
});


@override $WalletCopyWith<$Res> get wallet;

}
/// @nodoc
class _$AnalysisRefusedCopyWithImpl<$Res>
    implements $AnalysisRefusedCopyWith<$Res> {
  _$AnalysisRefusedCopyWithImpl(this._self, this._then);

  final AnalysisRefused _self;
  final $Res Function(AnalysisRefused) _then;

/// Create a copy of ConversationAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reason = null,Object? wallet = null,}) {
  return _then(AnalysisRefused(
reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,wallet: null == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as Wallet,
  ));
}

/// Create a copy of ConversationAnalysis
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
