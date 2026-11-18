// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PremiumPlan {

 String get productId; PlanPeriod get period; String get priceLabel;/// Prix de lancement ou promotionnel configuré dans le store, s'il existe.
 String? get introPriceLabel;
/// Create a copy of PremiumPlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PremiumPlanCopyWith<PremiumPlan> get copyWith => _$PremiumPlanCopyWithImpl<PremiumPlan>(this as PremiumPlan, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PremiumPlan&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.period, period) || other.period == period)&&(identical(other.priceLabel, priceLabel) || other.priceLabel == priceLabel)&&(identical(other.introPriceLabel, introPriceLabel) || other.introPriceLabel == introPriceLabel));
}


@override
int get hashCode => Object.hash(runtimeType,productId,period,priceLabel,introPriceLabel);

@override
String toString() {
  return 'PremiumPlan(productId: $productId, period: $period, priceLabel: $priceLabel, introPriceLabel: $introPriceLabel)';
}


}

/// @nodoc
abstract mixin class $PremiumPlanCopyWith<$Res>  {
  factory $PremiumPlanCopyWith(PremiumPlan value, $Res Function(PremiumPlan) _then) = _$PremiumPlanCopyWithImpl;
@useResult
$Res call({
 String productId, PlanPeriod period, String priceLabel, String? introPriceLabel
});




}
/// @nodoc
class _$PremiumPlanCopyWithImpl<$Res>
    implements $PremiumPlanCopyWith<$Res> {
  _$PremiumPlanCopyWithImpl(this._self, this._then);

  final PremiumPlan _self;
  final $Res Function(PremiumPlan) _then;

/// Create a copy of PremiumPlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? period = null,Object? priceLabel = null,Object? introPriceLabel = freezed,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as PlanPeriod,priceLabel: null == priceLabel ? _self.priceLabel : priceLabel // ignore: cast_nullable_to_non_nullable
as String,introPriceLabel: freezed == introPriceLabel ? _self.introPriceLabel : introPriceLabel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PremiumPlan].
extension PremiumPlanPatterns on PremiumPlan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PremiumPlan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PremiumPlan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PremiumPlan value)  $default,){
final _that = this;
switch (_that) {
case _PremiumPlan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PremiumPlan value)?  $default,){
final _that = this;
switch (_that) {
case _PremiumPlan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  PlanPeriod period,  String priceLabel,  String? introPriceLabel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PremiumPlan() when $default != null:
return $default(_that.productId,_that.period,_that.priceLabel,_that.introPriceLabel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  PlanPeriod period,  String priceLabel,  String? introPriceLabel)  $default,) {final _that = this;
switch (_that) {
case _PremiumPlan():
return $default(_that.productId,_that.period,_that.priceLabel,_that.introPriceLabel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  PlanPeriod period,  String priceLabel,  String? introPriceLabel)?  $default,) {final _that = this;
switch (_that) {
case _PremiumPlan() when $default != null:
return $default(_that.productId,_that.period,_that.priceLabel,_that.introPriceLabel);case _:
  return null;

}
}

}

/// @nodoc


class _PremiumPlan implements PremiumPlan {
  const _PremiumPlan({required this.productId, required this.period, required this.priceLabel, this.introPriceLabel});
  

@override final  String productId;
@override final  PlanPeriod period;
@override final  String priceLabel;
/// Prix de lancement ou promotionnel configuré dans le store, s'il existe.
@override final  String? introPriceLabel;

/// Create a copy of PremiumPlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PremiumPlanCopyWith<_PremiumPlan> get copyWith => __$PremiumPlanCopyWithImpl<_PremiumPlan>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PremiumPlan&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.period, period) || other.period == period)&&(identical(other.priceLabel, priceLabel) || other.priceLabel == priceLabel)&&(identical(other.introPriceLabel, introPriceLabel) || other.introPriceLabel == introPriceLabel));
}


@override
int get hashCode => Object.hash(runtimeType,productId,period,priceLabel,introPriceLabel);

@override
String toString() {
  return 'PremiumPlan(productId: $productId, period: $period, priceLabel: $priceLabel, introPriceLabel: $introPriceLabel)';
}


}

/// @nodoc
abstract mixin class _$PremiumPlanCopyWith<$Res> implements $PremiumPlanCopyWith<$Res> {
  factory _$PremiumPlanCopyWith(_PremiumPlan value, $Res Function(_PremiumPlan) _then) = __$PremiumPlanCopyWithImpl;
@override @useResult
$Res call({
 String productId, PlanPeriod period, String priceLabel, String? introPriceLabel
});




}
/// @nodoc
class __$PremiumPlanCopyWithImpl<$Res>
    implements _$PremiumPlanCopyWith<$Res> {
  __$PremiumPlanCopyWithImpl(this._self, this._then);

  final _PremiumPlan _self;
  final $Res Function(_PremiumPlan) _then;

/// Create a copy of PremiumPlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? period = null,Object? priceLabel = null,Object? introPriceLabel = freezed,}) {
  return _then(_PremiumPlan(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as PlanPeriod,priceLabel: null == priceLabel ? _self.priceLabel : priceLabel // ignore: cast_nullable_to_non_nullable
as String,introPriceLabel: freezed == introPriceLabel ? _self.introPriceLabel : introPriceLabel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$CreditPack {

 String get productId; int get credits; String get priceLabel;
/// Create a copy of CreditPack
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreditPackCopyWith<CreditPack> get copyWith => _$CreditPackCopyWithImpl<CreditPack>(this as CreditPack, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreditPack&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.credits, credits) || other.credits == credits)&&(identical(other.priceLabel, priceLabel) || other.priceLabel == priceLabel));
}


@override
int get hashCode => Object.hash(runtimeType,productId,credits,priceLabel);

@override
String toString() {
  return 'CreditPack(productId: $productId, credits: $credits, priceLabel: $priceLabel)';
}


}

/// @nodoc
abstract mixin class $CreditPackCopyWith<$Res>  {
  factory $CreditPackCopyWith(CreditPack value, $Res Function(CreditPack) _then) = _$CreditPackCopyWithImpl;
@useResult
$Res call({
 String productId, int credits, String priceLabel
});




}
/// @nodoc
class _$CreditPackCopyWithImpl<$Res>
    implements $CreditPackCopyWith<$Res> {
  _$CreditPackCopyWithImpl(this._self, this._then);

  final CreditPack _self;
  final $Res Function(CreditPack) _then;

/// Create a copy of CreditPack
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? credits = null,Object? priceLabel = null,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,credits: null == credits ? _self.credits : credits // ignore: cast_nullable_to_non_nullable
as int,priceLabel: null == priceLabel ? _self.priceLabel : priceLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreditPack].
extension CreditPackPatterns on CreditPack {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreditPack value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreditPack() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreditPack value)  $default,){
final _that = this;
switch (_that) {
case _CreditPack():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreditPack value)?  $default,){
final _that = this;
switch (_that) {
case _CreditPack() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  int credits,  String priceLabel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreditPack() when $default != null:
return $default(_that.productId,_that.credits,_that.priceLabel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  int credits,  String priceLabel)  $default,) {final _that = this;
switch (_that) {
case _CreditPack():
return $default(_that.productId,_that.credits,_that.priceLabel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  int credits,  String priceLabel)?  $default,) {final _that = this;
switch (_that) {
case _CreditPack() when $default != null:
return $default(_that.productId,_that.credits,_that.priceLabel);case _:
  return null;

}
}

}

/// @nodoc


class _CreditPack implements CreditPack {
  const _CreditPack({required this.productId, required this.credits, required this.priceLabel});
  

@override final  String productId;
@override final  int credits;
@override final  String priceLabel;

/// Create a copy of CreditPack
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreditPackCopyWith<_CreditPack> get copyWith => __$CreditPackCopyWithImpl<_CreditPack>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreditPack&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.credits, credits) || other.credits == credits)&&(identical(other.priceLabel, priceLabel) || other.priceLabel == priceLabel));
}


@override
int get hashCode => Object.hash(runtimeType,productId,credits,priceLabel);

@override
String toString() {
  return 'CreditPack(productId: $productId, credits: $credits, priceLabel: $priceLabel)';
}


}

/// @nodoc
abstract mixin class _$CreditPackCopyWith<$Res> implements $CreditPackCopyWith<$Res> {
  factory _$CreditPackCopyWith(_CreditPack value, $Res Function(_CreditPack) _then) = __$CreditPackCopyWithImpl;
@override @useResult
$Res call({
 String productId, int credits, String priceLabel
});




}
/// @nodoc
class __$CreditPackCopyWithImpl<$Res>
    implements _$CreditPackCopyWith<$Res> {
  __$CreditPackCopyWithImpl(this._self, this._then);

  final _CreditPack _self;
  final $Res Function(_CreditPack) _then;

/// Create a copy of CreditPack
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? credits = null,Object? priceLabel = null,}) {
  return _then(_CreditPack(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,credits: null == credits ? _self.credits : credits // ignore: cast_nullable_to_non_nullable
as int,priceLabel: null == priceLabel ? _self.priceLabel : priceLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$Catalog {

 List<PremiumPlan> get plans; List<CreditPack> get packs;
/// Create a copy of Catalog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogCopyWith<Catalog> get copyWith => _$CatalogCopyWithImpl<Catalog>(this as Catalog, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Catalog&&const DeepCollectionEquality().equals(other.plans, plans)&&const DeepCollectionEquality().equals(other.packs, packs));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(plans),const DeepCollectionEquality().hash(packs));

@override
String toString() {
  return 'Catalog(plans: $plans, packs: $packs)';
}


}

/// @nodoc
abstract mixin class $CatalogCopyWith<$Res>  {
  factory $CatalogCopyWith(Catalog value, $Res Function(Catalog) _then) = _$CatalogCopyWithImpl;
@useResult
$Res call({
 List<PremiumPlan> plans, List<CreditPack> packs
});




}
/// @nodoc
class _$CatalogCopyWithImpl<$Res>
    implements $CatalogCopyWith<$Res> {
  _$CatalogCopyWithImpl(this._self, this._then);

  final Catalog _self;
  final $Res Function(Catalog) _then;

/// Create a copy of Catalog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? plans = null,Object? packs = null,}) {
  return _then(_self.copyWith(
plans: null == plans ? _self.plans : plans // ignore: cast_nullable_to_non_nullable
as List<PremiumPlan>,packs: null == packs ? _self.packs : packs // ignore: cast_nullable_to_non_nullable
as List<CreditPack>,
  ));
}

}


/// Adds pattern-matching-related methods to [Catalog].
extension CatalogPatterns on Catalog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Catalog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Catalog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Catalog value)  $default,){
final _that = this;
switch (_that) {
case _Catalog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Catalog value)?  $default,){
final _that = this;
switch (_that) {
case _Catalog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PremiumPlan> plans,  List<CreditPack> packs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Catalog() when $default != null:
return $default(_that.plans,_that.packs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PremiumPlan> plans,  List<CreditPack> packs)  $default,) {final _that = this;
switch (_that) {
case _Catalog():
return $default(_that.plans,_that.packs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PremiumPlan> plans,  List<CreditPack> packs)?  $default,) {final _that = this;
switch (_that) {
case _Catalog() when $default != null:
return $default(_that.plans,_that.packs);case _:
  return null;

}
}

}

/// @nodoc


class _Catalog implements Catalog {
  const _Catalog({required final  List<PremiumPlan> plans, required final  List<CreditPack> packs}): _plans = plans,_packs = packs;
  

 final  List<PremiumPlan> _plans;
@override List<PremiumPlan> get plans {
  if (_plans is EqualUnmodifiableListView) return _plans;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_plans);
}

 final  List<CreditPack> _packs;
@override List<CreditPack> get packs {
  if (_packs is EqualUnmodifiableListView) return _packs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_packs);
}


/// Create a copy of Catalog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogCopyWith<_Catalog> get copyWith => __$CatalogCopyWithImpl<_Catalog>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Catalog&&const DeepCollectionEquality().equals(other._plans, _plans)&&const DeepCollectionEquality().equals(other._packs, _packs));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_plans),const DeepCollectionEquality().hash(_packs));

@override
String toString() {
  return 'Catalog(plans: $plans, packs: $packs)';
}


}

/// @nodoc
abstract mixin class _$CatalogCopyWith<$Res> implements $CatalogCopyWith<$Res> {
  factory _$CatalogCopyWith(_Catalog value, $Res Function(_Catalog) _then) = __$CatalogCopyWithImpl;
@override @useResult
$Res call({
 List<PremiumPlan> plans, List<CreditPack> packs
});




}
/// @nodoc
class __$CatalogCopyWithImpl<$Res>
    implements _$CatalogCopyWith<$Res> {
  __$CatalogCopyWithImpl(this._self, this._then);

  final _Catalog _self;
  final $Res Function(_Catalog) _then;

/// Create a copy of Catalog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? plans = null,Object? packs = null,}) {
  return _then(_Catalog(
plans: null == plans ? _self._plans : plans // ignore: cast_nullable_to_non_nullable
as List<PremiumPlan>,packs: null == packs ? _self._packs : packs // ignore: cast_nullable_to_non_nullable
as List<CreditPack>,
  ));
}


}

// dart format on
