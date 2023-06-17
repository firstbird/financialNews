import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe/service/imservice.dart';
import 'package:recipe/util/showmessage_util.dart';
import '../../service/activity.dart';
import 'event/moment_city_event.dart';
import 'state/moment_city_state.dart';


class MomentCityDataBloc extends Bloc<PostEvent, MomentCityState> {
  final ImService _imService = new ImService();

  MomentCityDataBloc():super(PostInitial()) {
    on<PostFetched>((event, emit) async {
      final currentState = state;
      try {
        if (!_hasReachedMax(currentState)) {
          if (currentState is PostInitial || currentState is PostFailure) {
            emit(PostLoading());
            final moments = await _imService
                .getMomentListByCity(0, event.locationCode, _errorResponse);
            emit(PostSuccess(moments: moments, hasReachedMax: moments.length < 6 ? true : false, isRefreshed: true));
            return;
          }
          //加载更多
          if (currentState is PostSuccess) {
            final moments = await _imService
                .getMomentListByCity(
                currentState.moments!.length, event.locationCode, _errorResponse);
             emit(moments.isEmpty
                ? currentState.copyWith(hasReachedMax: true)
                : PostSuccess(
                moments: currentState.moments! + moments,
                hasReachedMax: false,
                isRefreshed: false
            ));
          }
        }
      } catch(_){
        emit(PostFailure());
      }
    });

    on<Refreshed>((event, emit) async {
      emit(PostLoading());
      //     final moments = await _imService
      //         .getMomentListByCity(0, event.locationCode, _errorResponse);
      // emit(PostSuccess(moments: moments, hasReachedMax: moments.length < 6 ? true : false, isRefreshed: true));
    });
  }

  //@override
  // TODO: implement initialState
  //CityActivityState get initialState => PostInitial();


  @override
  void onTransition(Transition<PostEvent, MomentCityState> transition) {
    //print(transition);
    super.onTransition(transition);
  }

  bool _hasReachedMax(MomentCityState state) =>
      state is PostSuccess  && state.hasReachedMax;

  _errorResponse(String statusCode, String msg) {
    ShowMessage.showToast(msg);
  }
}
