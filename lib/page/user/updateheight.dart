import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../global.dart';
import '../../bloc/user/authentication_bloc.dart';
import '../../util/showmessage_util.dart';

class MyUpdateHeight extends StatelessWidget {
  Object? arguments;
  TextEditingController _textEditingController = new TextEditingController();
  String _type = "";
  String _content = "";
  static const HEIGHT_MIN = 100;
  static const HEIGHT_MAX = 230;
  MyUpdateHeight({this.arguments}){
    _type = (arguments as Map)["type"].toString();
    _content = (arguments as Map)["content"] == null ? "" : (arguments as Map)["content"].toString();
    _textEditingController.text = _content != null ? _content : "";
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationAuthenticated) {
          //Navigator.of(context).pop(_textEditingController.text);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          title: Text(_type == "1" ? '填写身高(cm)' : '', style: TextStyle(color: Colors.black, fontSize: 16)),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.only(top: 20,left: 10, right: 10),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _type == "1" ? heightInput() : signature(),
              Container(
                width:double.infinity,
                child: ElevatedButton(
                  child: Text('保存', style: TextStyle(color: Global.profile.fontColor),),
                  // color: Global.profile.backColor,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                  ),
                  onPressed: () async {
                    if(_type == "1") {
                      if (isInputValid()) {
                        BlocProvider.of<AuthenticationBloc>(context).add(UpdateUserHeightPressed(user: Global.profile.user!, height: int.tryParse(_textEditingController.text)!));
                        Navigator.of(context).pop(_textEditingController.text);
                      }
                      else {
                        ShowMessage.showToast("填写身高有误, 请检查");
                      }
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool isInputValid() {
    int height = int.tryParse(_textEditingController.text)!;
    return (height >= HEIGHT_MIN && height <= HEIGHT_MAX);
  }

  TextField heightInput(){
    return TextField(
      controller: _textEditingController,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ],
        onChanged: (value) {
          int? number = int.tryParse(value);
          if (number == null) {
            ShowMessage.showToast("填写身高有误, 请填写数字");
          }
        },

        style: TextStyle(fontSize: 14.0, color: Colors.black),//输入文本的样式
      decoration: InputDecoration(
        border: InputBorder.none,//去掉输入框的下滑线
        hintStyle: TextStyle(fontSize: 14),
        hintText: "请输入数字",
        filled: true,
        fillColor: Colors.white,
      )
    );
  }

  TextField signature(){
    return TextField(
          controller: _textEditingController,
          maxLength: 100,//最大长度，设置此项会让TextField右下角有一个输入数量的统计字符串
          maxLines: 9,//最大行数
          autocorrect: true,//是否自动更正
          autofocus: true,//是否自动对焦
          textAlign: TextAlign.left,//文本对齐方式
          style: TextStyle(fontSize: 14.0, color: Colors.black87),//输入文本的样式
          onChanged: (text) {//内容改变的回调
        },

        decoration: InputDecoration(
          border: InputBorder.none,//去掉输入框的下滑线
          hintStyle: TextStyle(fontSize: 14),
          hintText: "说说你的兴趣与爱好",
          filled: true,
          fillColor: Colors.white,
//          enabledBorder: OutlineInputBorder(
//            /*边角*/
//            borderRadius: BorderRadius.all(
//              Radius.circular(5), //边角为5
//            ),
//            borderSide: BorderSide(
//              color: Global.profile.backColor, //边线颜色为白色
//              width: 1, //边线宽度为2
//            ),
//          ),
//          focusedBorder: OutlineInputBorder(
//            borderSide: BorderSide(
//              color: Global.profile.backColor, //边框颜色为白色
//              width: 1, //宽度为5
//            ),
//            borderRadius: BorderRadius.all(
//              Radius.circular(5), //边角为30
//            ),
//          ),
        )
    );
  }
}
