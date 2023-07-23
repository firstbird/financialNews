import 'package:equatable/equatable.dart';
import '../../../model/user.dart';

abstract class  MySubscribeEvent extends Equatable {


  @override
  List<Object> get props => [];
}
///加载更多
class SubscribePostFetched extends MySubscribeEvent{
  final User? user;
  final List<int>? ids;
  SubscribePostFetched({required this.user, this.ids});
}
///刷新
class SubscribeRefreshed extends MySubscribeEvent{
  final User user;
  final List<int>? ids;

  SubscribeRefreshed({required this.user, this.ids});
}

