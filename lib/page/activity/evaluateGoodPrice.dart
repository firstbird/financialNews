import 'dart:async';
// import 'package:amap_flutter_location/amap_flutter_location.dart';
// import 'package:amap_flutter_location/amap_location_option.dart';
// import 'package:amap_flutter_map/amap_flutter_map.dart';

// import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '../../model/evaluateactivity.dart';
import '../../model/evaluategoodsitem.dart';
import '../../model/grouppurchase/goodpice_model.dart';
import '../../model/user.dart';
import '../../model/activity.dart';
import '../../model/aliyun/securitytoken.dart';
import '../../common/iconfont.dart';
import '../../service/gpservice.dart';
import '../../util/common_util.dart';
import '../../util/showmessage_util.dart';
import '../../util/permission_util.dart';
import '../../service/activity.dart';
import '../../service/aliyun.dart';
import '../../widget/circle_headimage.dart';
import '../../widget/captcha/block_puzzle_captcha.dart';
import '../../widget/loadingprogress.dart';
import '../../global.dart';

class EvaluateGoodPriceActivity extends StatefulWidget {

  String goodPriceContent = "";
  // String evaluateimagespath = "";
  String goodpriceid = "";
  int touid = 0;
  Object? arguments;

  EvaluateGoodPriceActivity({required this.arguments}){
    if(arguments != null){
      goodPriceContent = (arguments as Map)["content"];
      goodpriceid = (arguments as Map)["goodpriceid"];
      // evaluateimagespath = (arguments as Map)["pic"];
      touid = (arguments as Map)["touid"];
    }
  }

  @override
  _EvaluateGoodPriceActivityState createState() => _EvaluateGoodPriceActivityState();
}

class _EvaluateGoodPriceActivityState extends State<EvaluateGoodPriceActivity> {
  TextEditingController _textContentController = new TextEditingController();

  late User _user;
  AliyunService _aliyunService = new AliyunService();

  bool _isButtonEnable = true;
  List<AssetEntity> _images = [];
  int _imageMax = 4;//最多上传4张图

  int _coverimgIndex= 0;
  bool _loading = false;
  // bool _ispublic = true;//是否公开

  int oldImageCount = 0;//旧的图片数量
  ActivityService _activityService = new ActivityService();
  SecurityToken? _securityToken;
  List<String> _imagesUrl = [];
  List<String> _imagesWH = [];//图片的分辨率
  FocusNode _contentfocusNode = FocusNode();
  List<String> _oldImagesUrl = [];
  int _paytype = 0;
  GPService _gpService = GPService();
  double _currentSliderValue = 0;

  late Map<String, Object> _locationResult;

  @override
  void dispose() {
    // TODO: implement dispose
    _textContentController.dispose();
    // _textNameController.dispose();
    _contentfocusNode.dispose();

    super.dispose();
  }

  Future<bool> requestPermission() async {
    final permissions = await Permission.locationWhenInUse.request();

    if (permissions.isGranted) {
      return true;
    } else {
      debugPrint('需要定位权限!');
      return false;
    }
  }

  @override
  void initState(){
    _user = Global.profile.user!;
    super.initState();

    // if(widget.evaluateimagespath != null && widget.evaluateimagespath.isNotEmpty){
    //   List<String> oldImages = widget.evaluateimagespath.split(',');
    //   oldImageCount = oldImages.length;
    //   oldImages.forEach((element) {
    //     Uri u = Uri.parse(element);
    //     String tem = u.path.substring(1, u.path.length);
    //     _imagesUrl.add(tem);
    //     _imagesWH.add("300, 300");//优惠拼玩没有大小
    //     _oldImagesUrl.add(element);
    //   });
    //
    // }
  }

  @override
  Widget build(BuildContext context) {
    _user = Global.profile.user!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),iconSize: 20, color: Colors.black, onPressed: (){Navigator.pop(context);},),
        title: Text('', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: new MyLoadingProgress(loading: _loading, isNetError: false, child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: ListView(
          // item 内容内边距
          children: <Widget>[
            buildEvaluateInfo(),
            SizedBox(height: 6,),
            Text(
              '请滑动滚动条进行评分 👇 ',style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black45),
            ),
            buildRatingSlider(),
            SizedBox(height: 6,),
            Text(
              '选择图片上传 👇',style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black45),
            ),
            SizedBox(height: 6,),
            buildGridView(),
            SizedBox(height: 9,),

          ],
        ),
      ), msg: '发布中',),
      bottomNavigationBar: buildIssuedButton(context),
    );
  }
  Widget buildRatingSlider() {
    return

      Row(
        children: [
          Container(
            width: 230,
            child: Slider(
            value: _currentSliderValue,
            min: 0,
            max: 5,
            divisions: 5,
            label: _currentSliderValue.round().toString(),
            autofocus: true,
            onChanged: (double value) {
              setState(() {
                _currentSliderValue = value;
              });
            },),
          ),
          SizedBox(width: 5,),
          Text(
            '当前评分: ${_currentSliderValue}',style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.yellowAccent),
          ),
          Spacer()
        ],
      );

  }
  //社团活动描述
  TextField buildEvaluateInfo(){
    return TextField(
        focusNode: _contentfocusNode,
        controller: _textContentController,
        maxLength: 500,//最大长度，设置此项会让TextField右下角有一个输入数量的统计字符串
        maxLines: 15,//最大行数
        autocorrect: true,//是否自动更正
        autofocus: false,//是否自动对焦
        textAlign: TextAlign.left,//文本对齐方式
        style: TextStyle(color: Colors.black87, fontSize: 14, ),//输入文本的样式
        onChanged: (text) {//内容改变的回调
        },

        decoration: InputDecoration(
          counterText:"",
          hintText: "亲，请对该商户的服务进行评价~",
          hintStyle: TextStyle(color: Colors.black45, fontSize: 14),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 10,  bottom: 0, right: 10),
        )
    );
  }
  //imageGridview
  Widget buildGridView() {
    List<Widget> lists = List.generate(_images.length + oldImageCount == _imageMax ? _images.length  + oldImageCount: _images.length + 1 + oldImageCount,
            (index) {
          if(index == (_images.length + oldImageCount) && index < _imageMax){
            return Container(
              child: Center(
                child: IconButton(
                  alignment: Alignment.center,
                  icon: Icon(IconFont.icon_tianjiajiahaowubiankuang, size: 30, color: Colors.grey,),
                  onPressed: (){
                    _contentfocusNode.unfocus();
                    loadAssets();
                  },
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.all(new Radius.circular(5.0)),
              ),
            );
          }
          else if(index == _imageMax){
            return Container();
          }
          else if(index < (_images.length + oldImageCount)){
            Widget tem = SizedBox.shrink();
            if(index < oldImageCount){
              tem = ClipRRectOhterHeadImageContainer(imageUrl: _oldImagesUrl[index], width: 300,height: 300,);
            }
            else{
              tem = ClipRRect(
                child: ExtendedImage(
                  image: AssetEntityImageProvider(
                      _images[index-oldImageCount],
                  ),
                  width: 300,
                  height: 300,
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              );
            }
            return Stack(
              children: <Widget>[
                tem,
                Positioned(
                  right: 0.08,
                  top: 0.08,
                  child: new GestureDetector(
                    onTap: (){
                      if(index >= oldImageCount){
                        _images.removeAt(index - oldImageCount);
                      }
                      else if(oldImageCount > 0){
                        oldImageCount = oldImageCount-1;
                        _oldImagesUrl.remove(index);
                      }
                      _imagesUrl.removeAt(index);
                      _imagesWH.removeAt(index);

                      if(index == _coverimgIndex)
                        _coverimgIndex=0;
                      setState(() {

                      });

                    },
                    child: new Container(
                      decoration: new BoxDecoration(
                        color: Colors.black45,
                        shape: BoxShape.circle,
                      ),
                      child: new Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20.0,
                      ),
                    ),
                  ),
                ),

              ],
            );
          }
          else{
            return SizedBox.shrink();
          }
        }
    );
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: GridView.count(
          shrinkWrap: true, // 自动高
          physics: NeverScrollableScrollPhysics(),// 添加
          childAspectRatio: 1.0,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 4,
          children: lists),
    );
  }
  //发布按钮
  Container buildIssuedButton(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        height: 40,
        child: TextButton(
            // color: Global.profile.backColor,
            child: Text(
              '发布评论',style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            // shape: RoundedRectangleBorder(
            //     side: BorderSide.none,
            //     borderRadius: BorderRadius.all(Radius.circular(9))
            // ),
            style: ElevatedButton.styleFrom(
              primary: Global.profile.backColor,
              elevation: 5,
              // padding: const EdgeInsets.all(12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),

            onPressed: () async{
              try{
                if(_isButtonEnable) {

                  if (_textContentController.text == "") {
                    ShowMessage.showToast("亲，您还没写评价哦~");
                    return;
                  }

                  setState(() {
                    _loading = true;
                  });
                  _isButtonEnable = false;
                  EvaluateGoodsItem? value = await _gpService.updateEvaluateGoodPrice(widget.goodpriceid, Global.profile.user!.uid, Global.profile.user!.token!,
                      widget.touid, _textContentController.text,
                      _currentSliderValue.toInt(),
                      _imagesUrl.join(","),
                      widget.goodPriceContent,
                      errorCallBack);

                  if (value != null) {
                    GoodPiceModel? goodPiceModel = await _gpService.getGoodPriceInfo(widget.goodpriceid);
                    Navigator.pushNamed(context, '/GoodPriceInfo', arguments: {"goodprice": goodPiceModel});
                  }
                  _loading = false;
                  _isButtonEnable = true;
                }
              }
              catch(e)
              {
                print("[Issue evaluate good price] exception: ${e.toString()}");
                _isButtonEnable = true;
                ShowMessage.showToast("网络不给力，请再试一下!");}
                setState(() {
                  _loading = false;
                });
            }),
      );
  }

  errorCallBack(String statusCode, String msg) {
    print("evaluate goodprice error, statusCode ${statusCode}, msg: ${msg}");
  }
  //加载图片并处理
  Future<void> loadAssets() async {
    List<AssetEntity>? resultList;

    try {
      resultList = await AssetPicker.pickAssets(
        context,
          pickerConfig: AssetPickerConfig(
        maxAssets: _imageMax - oldImageCount,
        selectedAssets: _images,
        requestType: RequestType.image,),
      );

    } on Exception catch (e) {
      print(e.toString());
    }
    if (resultList != null && resultList.length != 0) {
      //添加图片并上传oss 1.申请oss临时token，1000s后过期
      _securityToken = await _aliyunService.getActivitySecurityToken(_user.token!, _user.uid);
      if (_securityToken != null) {
        for (int i = 0; i < resultList.length; i++) {
          int width = resultList[i].orientatedWidth;
          int height = resultList[i].orientatedHeight;
          String url = await CommonUtil.upLoadImage((await resultList[i].file)!, _securityToken!, _aliyunService);
          if(!_imagesUrl.contains(url)) {
            _imagesUrl.add(url);
            _imagesWH.add("${width},${height}");
          }
        }
        if (!mounted) return;
        setState(() {
          if(resultList!.length != 0)
            _images = resultList;
        });

      }
    }
  }

}
