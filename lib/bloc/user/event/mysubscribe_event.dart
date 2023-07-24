import 'package:equatable/equatable.dart';
import '../../../model/user.dart';

abstract class  MySubscribeEvent extends Equatable {


  @override
  List<Object> get props => [];
}
///加载更多
class SubscribePostFetched extends MySubscribeEvent{
  final User? user;
  final int type;
  SubscribePostFetched({required this.user, required this.type});
}
///刷新
class SubscribeRefreshed extends MySubscribeEvent{
  final User user;
  final int type;

  SubscribeRefreshed({required this.user, required this.type});
}

