import 'package:equatable/equatable.dart';
import 'package:recipe/model/bugsuggestion/moment.dart';

abstract class MomentCityState extends Equatable {
  const MomentCityState();

  @override
  List<Object> get props => [];
}

class PostInitial extends MomentCityState {}

class PostFailure extends MomentCityState {}

class PostSuccess extends MomentCityState {
  List<Moment>? moments;
  bool hasReachedMax = false;
  bool isRefreshed = false;
  PostSuccess({
    this.moments,
    this.hasReachedMax = false,
    this.isRefreshed = false,
  });

  PostSuccess copyWith({
    List<Moment>? posts,
    bool hasReachedMax = false,
    bool isRefreshed = false
  }) {
    return PostSuccess(
      moments: moments ?? this.moments,
      hasReachedMax: hasReachedMax,
      isRefreshed: isRefreshed,

    );
  }

  @override
  List<Object> get props => [moments??[], hasReachedMax];

  @override
  String toString() =>
      'PostSuccess { posts: ${moments}, hasReachedMax: $hasReachedMax }';
}

class PostLoading extends MomentCityState {}
