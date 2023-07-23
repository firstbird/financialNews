import 'package:equatable/equatable.dart';

import '../../../model/user.dart';
import '../../../model/activity.dart';


abstract class MySubscribeState extends Equatable {
  const MySubscribeState();


  @override
  List<Object> get props => [];
}

class PostInitial extends MySubscribeState {}

class PostFailure extends MySubscribeState {}

class PostSuccess extends MySubscribeState {
  final List<User> users;
  final List<Activity> activitys;
  bool hasReachedActivityMax = false;
  bool hasReachedUserMax = false;
  String? time = "";

  PostSuccess({
    required this.users,
    required this.activitys,
    this.hasReachedActivityMax = false,
    this.hasReachedUserMax = false,
    this.time
  });

  PostSuccess copyWith({
    bool hasReachedActivityMax = false,
    bool hasReachedUserMax = false,
  }) {
    return PostSuccess(
      users: users,
      activitys: activitys,
      hasReachedActivityMax: hasReachedActivityMax,
      hasReachedUserMax: hasReachedUserMax,
      time: time
    );
  }

  @override
  List<Object> get props => [users, activitys, hasReachedActivityMax, hasReachedUserMax, time??"" ];

  @override
  String toString() =>
      'PostSuccess { posts: ${users.length}, hasReachedActivityMax: $hasReachedActivityMax, hasReachedActivityMax: $hasReachedUserMax }';
}

class PostLoading extends MySubscribeState {}

class NoLogin extends MySubscribeState {}

