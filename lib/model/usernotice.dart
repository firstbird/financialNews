import 'package:json_annotation/json_annotation.dart';

part 'usernotice.g.dart';

@JsonSerializable()
class UserNotice{
  int uid;

  int unreadComment;
  int readCommentindex;
  int unreadReply;
  int readReplyindex;
  int unreadSysnotice;
  int readSysnoticeindex;
  int unreadMember;
  int readMember;
  int unreadFollow;
  int readFollow;
  int unevaluateActivity;
  int evaluateActivity;//这个是已评论的活动数量
  int unreadEvaluate;//这个是未读的评价数量
  int readEvaluate;//已读的评价数量
  int unreadEvaluatereply;//未读评价回复
  int readEvaluatereply;//已读评价回复
  int unreadFriend;//未读朋友申请通过通知
  int readFriend;//已读朋友申请通过通知
  int isUserUpdate;
  int unreadShared;//来自朋友的分享
  int readShared;//已读的分享
  int unreadOrderpending;//新的待支付订单数量
  int unreadOrderfinish;//新的待确认订单数量
  int unreadActlike;//活动点赞数量
  int readActlike;//活动已读点赞数量
  int unreadCommentlike;//留言点赞
  int readCommentlike;//留言点赞
  int unreadEvaluatelike;//未读评价点赞
  int readEvaluatelike;//已读评价点赞
  int unreadBuglike;//未读bug点赞
  int readBuglike;//已读bug点赞
  int unreadSuggestlike;//未读建议点赞
  int readSuggestlike;//已读建议点赞
  int unreadMomentlike;
  int readMomentlike;
  int unreadBugcomment;//未读的bugcomment
  int readBugcomment;//已读的bug评论
  int unreadSuggestcomment;//未读的建议评论
  int readSuggestcomment;//已读的建议评论
  int unreadMomentcomment;
  int readMomentcomment;
  int unreadBugreply;
  int readBugreply;
  int unreadSuggestreply;
  int readSuggestreply;
  int unreadMomentreply;
  int readMementreply;
  int unreadGoodpricecomment;//未读的优惠评论
  int readGoodpricecommentindex;//已读的优惠评论
  int unreadGoodpricereply;//未读的优惠回复
  int readGoodpricereplyindex;//已读的优惠回复
  int unreadBugcommentlike;
  int readBugcommentlike;//bug留言点赞
  int unreadSuggestcommentlike;
  int readSuggestcommentlike;//suggest留言点赞
  int unreadMomentcommentlike;
  int readMomentcommentlike;
  int unreadGoodpricecommentlike;//优惠评论点赞
  int readGoodpricecommentlike;//已读的优惠评论点赞
  int unreadGpmsg;
  int readGpmsg;
  int unreadCommunitymsg;
  int readCommunitymsg;
  int unreadSinglemsg;
  int readSinglemsg;
  int orderExpiration;


  UserNotice(this.uid, this.unreadComment, this.readCommentindex,  this.unreadReply, this.readReplyindex,
      this.unreadSysnotice, this.readSysnoticeindex, this.unreadMember, this.readMember, this.unreadFollow, this.readFollow,
      this.unevaluateActivity, this.evaluateActivity, this.unreadEvaluate, this.readEvaluate, this.unreadEvaluatereply, this.readEvaluatereply,
      this.unreadFriend, this.readFriend, this.isUserUpdate, this.unreadShared, this.readShared, this.unreadOrderpending, this.unreadOrderfinish,
      this.unreadActlike, this.readActlike, this.unreadCommentlike, this.readCommentlike, this.unreadEvaluatelike, this.readEvaluatelike,
      this.unreadBuglike, this.readBuglike, this.unreadSuggestlike, this.readSuggestlike, this.unreadBugcomment, this.readBugcomment,
      this.unreadSuggestcomment, this.readSuggestcomment, this.unreadBugreply, this.readBugreply, this.unreadSuggestreply,
      this.readSuggestreply, this.unreadBugcommentlike, this.readBugcommentlike, this.unreadSuggestcommentlike, this.readSuggestcommentlike,
      this.unreadGpmsg, this.readGpmsg, this.unreadCommunitymsg, this.readCommunitymsg, this.unreadSinglemsg, this.readSinglemsg,
      this.unreadGoodpricecomment, this.readGoodpricecommentindex, this.unreadGoodpricereply, this.readGoodpricereplyindex,
      this.unreadGoodpricecommentlike, this.readGoodpricecommentlike, this.orderExpiration, this.unreadMomentlike, this.readMomentlike,
      this.unreadMomentcomment,this.readMomentcomment,this.unreadMomentreply,this.readMementreply, this.unreadMomentcommentlike, this.readMomentcommentlike);



  Map<String, dynamic> toJson() => _$UserNoticeToJson(this);
  factory UserNotice.fromJson(Map<String, dynamic> json) => _$UserNoticeFromJson(json);
}