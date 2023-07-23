import 'package:bloc/bloc.dart';
import '../../model/activity.dart';
import '../../model/dynamic.dart';
import '../../model/user.dart';
import '../../service/activity.dart';
import '../../service/userservice.dart';

import 'event/mysubscribe_event.dart';
import 'state/mysubscribe_state.dart';

class MySubscribeBloc extends Bloc<MySubscribeEvent, MySubscribeState> {
  final UserService _userService = new UserService();
  final ActivityService _activityService = new ActivityService();

  MySubscribeBloc():super(PostInitial()) {
    on<SubscribePostFetched>((event, emit) async {
      final currentState = state;
      try {
          if (currentState is PostInitial) {
            if (event.user == null) {
              emit(NoLogin());
              return;
            }
            emit(PostLoading());
            users = await _userService.getFollowUsers(
                0, event.user!.uid, event.user!.token!);
            if (users != null && users.length > 0) {
              activitys = await _activityService.getActivityListByFollow(
                  0, users);
            }
            emit(PostSuccess(users: users, activitys: activitys, hasReachedActivityMax: false,
                hasReachedUserMax: false));
            return;
          }
          //加载更多
      }catch(_){
        emit(PostFailure());
      }
    });


  }

  // @override
  // // TODO: implement initialState
  // MyFollowState get initialState => PostInitial();
  List<User> users = [];
  List<Activity> activitys = [];

  @override
  Stream<MySubscribeState> mapEventToState(MySubscribeEvent event) async* {
    final currentState = state;
    try {
      if (event is SubscribePostFetched ) {
        if (currentState is PostInitial) {
          if(event.user == null){
            yield NoLogin();
            return;
          }
          yield PostLoading();
          users = await _userService.getFollowUsers(0, event.user!.uid, event.user!.token!);
          if(users != null &&users.length  > 0) {
            activitys = await _activityService.getActivityListByFollow(0, users);
          }
          yield PostSuccess(users: users, activitys: activitys, hasReachedActivityMax: false,
              hasReachedUserMax: false);
          return;
        }
        //加载更多
      }

      if (event is SubscribeRefreshed){
        users = await _userService.getFollowUsers(0, event.user.uid, event.user.token!);
        if(users != null && users.length > 0) {
          activitys = await _activityService.getActivityListByFollow(0, users);
        }
        yield PostSuccess(users: users, activitys: activitys, hasReachedActivityMax: false, hasReachedUserMax: false);
      }
    }
    catch(_){
      yield PostFailure();
    }
  }

  @override
  void onTransition(Transition<MySubscribeEvent, MySubscribeState> transition) {
    //print(transition);
    super.onTransition(transition);
  }
}

Map<String, List<Dynamic>> groupData(List<Dynamic> myDynamics){
  Map<String, List<Dynamic>> map = new Map.fromIterable(
      myDynamics,
      key: (key) => key.createtime.substring(0, 10),
      value: (value){
        return myDynamics.where((item) => (item.createtime.substring(0, 10) == value.createtime.substring(0, 10))).toList();
      }
  );
  return map;
}