import 'package:equatable/equatable.dart';

import '../../../model/subscription.dart';
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
  // final List<User> users;
  final List<Subscription> subscriptions;
  bool hasReachedActivityMax = false;
  bool hasReachedUserMax = false;
  String? time = "";

  PostSuccess({
    // required this.users,
    required this.subscriptions,
    this.hasReachedActivityMax = false,
    this.hasReachedUserMax = false,
    this.time
  });

  PostSuccess copyWith({
    bool hasReachedActivityMax = false,
    bool hasReachedUserMax = false,
  }) {
    return PostSuccess(
      // users: users,
      subscriptions: subscriptions,
      hasReachedActivityMax: hasReachedActivityMax,
      hasReachedUserMax: hasReachedUserMax,
      time: time
    );
  }

  @override
  List<Object> get props => [subscriptions, hasReachedActivityMax, hasReachedUserMax, time??"" ];

  @override
  String toString() =>
      'PostSuccess { posts: ${subscriptions.length}, hasReachedActivityMax: $hasReachedActivityMax, hasReachedActivityMax: $hasReachedUserMax }';
}

class PostLoading extends MySubscribeState {}

class NoLogin extends MySubscribeState {}

