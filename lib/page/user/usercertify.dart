import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recipe/model/activity.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:crypto/crypto.dart';


import '../../model/user.dart';
import '../../model/aliyun/securitytoken.dart';
import '../../util/common_util.dart';
import '../../util/showmessage_util.dart';
import '../../common/iconfont.dart';
import '../../service/aliyun.dart';
import '../../service/userservice.dart';
import '../../bloc/user/authentication_bloc.dart';
import '../../widget/circle_headimage.dart';
import '../../widget/my_divider.dart';
import '../../widget/interest.dart';
import '../../widget/photo/playrecorder.dart';
import '../../global.dart';
import '../../widget/my_divider.dart';


class MyCertifyEdit extends StatefulWidget {
  @override
  _MyUserCertifyEditState createState() => _MyUserCertifyEditState();
}

class _MyUserCertifyEditState extends State<MyCertifyEdit> {
  AliyunService _aliyunService = new AliyunService();
  late User user;
  late AuthenticationBloc _bloc;
  double fontsize = 15;
  double contentfontsize = 14;
  final _picker = ImagePicker();
  double _pageWidth = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = Global.profile.user!;
    _bloc = BlocProvider.of<AuthenticationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    _pageWidth = MediaQuery.of(context).size.width - 28; //28是左右间隔

    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationUnauthenticated) {
          ShowMessage.showToast(state.error!);
        }
      },
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          buildWhen: (previousState, state) {
            if(state is AuthenticationAuthenticated) {
              return true;
            }
            else
              return false;
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
                title: Text('用户认证', style: TextStyle(color: Colors.black, fontSize: 16)),
                centerTitle: true,
              ),
              body: Container(
                margin: EdgeInsets.only(top: 10, bottom: 20),
                color: Colors.white,
                child: ListView(
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        onTap: (){
                          showDemoActionSheet(
                            context: context,
                            imageCategory: "education",
                            child: CupertinoActionSheet(
                              //message: const Text('Please select the best mode from the options below.'),
                              actions: <Widget>[
                                CupertinoActionSheetAction(
                                  child: const Text('拍照', style: TextStyle(color: Colors.grey),),
                                  onPressed: () {
                                    Navigator.pop(context, 'Camera');
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: const Text('相册', style: TextStyle(color: Colors.grey)),
                                  onPressed: () {
                                    Navigator.pop(context, 'Gallery');
                                  },
                                ),
                              ],
                              cancelButton: CupertinoActionSheetAction(
                                child: const Text('取消', style: TextStyle(color: Colors.grey)),
                                isDefaultAction: true,
                                onPressed: () {
                                  Navigator.pop(context, 'Cancel');
                                },
                              ),
                            ),
                          );
                        },
                        title: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('请上传学历认证照片, 可在学信网上查询后截图:', style: TextStyle(color: Colors.black45)),
                              Row(
                                children: [
                                  Text('学历认证照片上传'),
                                  Icon(Icons.keyboard_arrow_right),
                                ],
                              ),
                              _buildCertifyImage(user.educationImage),
                              // user.educationImage != "" ? NoCacheClipRRectOhterHeadImage(imageUrl: user.educationImage, cir: 8, uid: user.uid,) : Image.asset("images/icon_nullimg.png"),
                            ],
                          ),
                        ),

                      ),
                    ),// 学历认证照片上传
                    MyDivider(),
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        onTap: (){
                          showDemoActionSheet(
                            context: context,
                            imageCategory: "earning",
                            child: CupertinoActionSheet(
                              //message: const Text('Please select the best mode from the options below.'),
                              actions: <Widget>[
                                CupertinoActionSheetAction(
                                  child: const Text('拍照', style: TextStyle(color: Colors.grey),),
                                  onPressed: () {
                                    Navigator.pop(context, 'Camera');
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: const Text('相册', style: TextStyle(color: Colors.grey)),
                                  onPressed: () {
                                    Navigator.pop(context, 'Gallery');
                                  },
                                ),
                              ],
                              cancelButton: CupertinoActionSheetAction(
                                child: const Text('取消', style: TextStyle(color: Colors.grey)),
                                isDefaultAction: true,
                                onPressed: () {
                                  Navigator.pop(context, 'Cancel');
                                },
                              ),
                            ),
                          );
                        },
                        title: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('请上传能表面您真实收入的凭证照片, 形式不限:', style: TextStyle(color: Colors.black45)),
                              Row(
                                children: [
                                  Text('收入认证照片上传'),
                                  Icon(Icons.keyboard_arrow_right),
                                ],
                              ),
                              _buildCertifyImage(user.earningImage),
                              // user.earningImage != "" ? NoCacheClipRRectOhterHeadImage(imageUrl: user.earningImage, cir: 8, uid: user.uid,) : Image.asset("images/icon_nullimg.png"),
                            ],
                          ),
                        ),
                      ),
                    ), // 收入认证上传
                  ],
                ),
              ),
            );
          }
    ),);
  }

  Widget _buildCertifyImage(String imageUrl) {
    if (imageUrl == "") {
      return Image.asset("images/icon_nullimg.png");
    }
    return Image.network(
      imageUrl,
      fit: BoxFit.contain,
      width: _pageWidth,
    );
  }
  //计算高度
  double getImageWH(Activity activity){
    double width = double.parse(activity.coverimgwh.split(',')[0]);
    double height = double.parse(activity.coverimgwh.split(',')[1]);
    double ratio = width/height;//宽高比
    double retheight = (_pageWidth.floor().toDouble()) / ratio;

    return retheight; //图片缩放高度
  }

  void showDefaultYearPicker(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    if(user.birthday!= null && user.birthday!.isNotEmpty){
      selectedDate = DateTime.parse(user.birthday!);
    }
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate, // 初始日期
      firstDate: DateTime(1900), //
      lastDate: DateTime(2100),
      locale: Locale('zh'),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark(),
          child: child!,
        );
      }
    ).then((DateTime? val){
      if(Global.profile.user!.birthday!=val.toString().substring(0, 10)){
        _bloc.add(UpdateUserBirthdayPressed(user: user, birthday: val.toString().substring(0, 10)));
      }
    }).catchError((err) {
      //print(err);
    });

    if (date == null) {
      return;
    }

    setState(() {
      selectedDate = date;
    });
  }

  void showDemoActionSheet({required BuildContext context, required Widget child, required String imageCategory}) {
    File? imageFile;
    File? croppedFile;
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((value) async {
      if (value != null) {
        if(value == "Camera"){
          XFile? image = await _picker.pickImage(source: ImageSource.camera);
          imageFile = File(image!.path);
        }else if(value == "Gallery"){
          XFile? image;
          if(Platform.isIOS ) {
            image = await _picker.pickImage(source: ImageSource.gallery);
            if(image != null) {
              imageFile = File(image.path);
            }
          }

          if(Platform.isAndroid){
            List<AssetEntity>? resultList = await AssetPicker.pickAssets(
              context,
              pickerConfig: AssetPickerConfig(
              maxAssets: 1,
              requestType: RequestType.image,
              ),
            );

            if(resultList != null && resultList.length > 0){
              imageFile = await (await resultList[0].file)!;
            }
          }
        }
        else{
          return;
        }
      }
      if(imageFile != null){
        croppedFile = await ImageCropper().cropImage(
            maxWidth: 750,
            maxHeight: 750,
            compressQuality: 19,
            sourcePath: imageFile!.path,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
            ],
            androidUiSettings: AndroidUiSettings(
                toolbarTitle: '裁剪',
                toolbarColor: Colors.deepOrange,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: true),
            iosUiSettings: IOSUiSettings(
                title: '裁剪',
                minimumAspectRatio: 1.0,
                aspectRatioLockEnabled: true
            )
        );
        if (croppedFile !=null) {
          String ossimagpath = "";
          String serverossimg = "";
          //转成png格式
          final Directory _directory = await getTemporaryDirectory();
          final Directory _imageDirectory =
              await new Directory('${_directory.path}/${imageCategory}/images/')
              .create(recursive: true);
          String _path = _imageDirectory.path;
          Uint8List imageData = await croppedFile!.readAsBytes();
          String md5name = md5.convert(imageData).toString();
          // String md5name = user.uid.toString();
          File imageFile = new File('${_path}originalImage_$md5name.png')
            ..writeAsBytesSync(imageData);

          //上传图片到oss
          SecurityToken? securityToken = await _aliyunService.getUserProfileSecurityToken(user.token!,  user.uid);
          if(securityToken != null) {
            serverossimg = await _aliyunService.uploadImage(
                securityToken, imageFile.path, '${md5name}.png', user.uid);
            ossimagpath = securityToken.host + '/' + serverossimg;
          }
          if(ossimagpath.isNotEmpty){
            if (imageCategory == "earning") {
              _bloc.add(UpdateEarningImagePressed(user: user, imgpath: ossimagpath, serverimgpath: serverossimg));
            } else if (imageCategory == "education") {
              _bloc.add(UpdateEducationImagePressed(user: user, imgpath: ossimagpath, serverimgpath: serverossimg));
            }
          }
        }
      }
    });
  }
}


//性别选择
class GenderChooseDialog extends Dialog {
  GenderChooseDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Padding(
        padding: const EdgeInsets.all(12.0),
        child: new Material(
            type: MaterialType.transparency,
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                      decoration: ShapeDecoration(
                          color: Color(0xFFFFFFFF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ))),
                      margin: const EdgeInsets.all(12.0),
                      child: new Column(children: <Widget>[
                        new Padding(
                            padding: const EdgeInsets.fromLTRB(
                                10.0, 10.0, 10.0, 10.0),
                            child: Center(
                                child: new Text('性别选择',
                                    style: new TextStyle(
                                      fontSize: 20.0, color: Colors.black
                                    )))),
                        MyDivider(),
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              _genderChooseItemMan(context),
                              _genderChooseItemGirl(context),
                            ]),
                        MyDivider(),
                        new Padding(
                            padding: const EdgeInsets.fromLTRB(
                                5.0, 5.0, 5.0, 10.0),
                            child: Center(
                                child: new Text('',
                                    style: new TextStyle(
                                        fontSize: 20.0, color: Colors.black
                                    )))),

                      ]))
                ])));
  }

  Widget _genderChooseItemMan(BuildContext context) {
    return GestureDetector(
        onTap: (){
          Navigator.of(context).pop('1');
        },
        child: Column(children: <Widget>[
          Container(
            width: 70,
            height: 70,
            child: Center(
              child: Icon(IconFont.icon_nan,size: 50, color:  Colors.blue,) )
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
              child: Text('男',style: TextStyle(
                  color:  Colors.blue,
                  fontSize: 20.0))),
        ]));
  }

  Widget _genderChooseItemGirl(BuildContext context) {
    return GestureDetector(
        onTap: (){
          Navigator.of(context).pop('0');
        },
        child: Column(children: <Widget>[
          Container(
            width: 70,
            height: 70,
            child: Center(
              child: Icon(IconFont.icon_nv, size: 50,
                color:  Colors.pinkAccent,),)
              ,),
          Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
              child: Text('女',style: TextStyle(
                  color:  Colors.pinkAccent,
                  fontSize: 20.0))),
        ]));
  }

  Widget _genderChooseItemWeiZhi(BuildContext context) {
    return GestureDetector(
        onTap: (){
          Navigator.of(context).pop('2');
        },
        child: Column(children: <Widget>[
          Container(
            width: 70,
            height: 70,
            child: Center(
              child: Icon(IconFont.icon_tianqi_weizhi, size: 50,
                color:  Colors.grey,),),),
          Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
              child: Text('保密',style: TextStyle(
                  color:  Colors.grey,
                  fontSize: 20.0))),
        ]));
  }
}

