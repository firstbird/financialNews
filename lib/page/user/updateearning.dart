import 'package:flutter/material.dart';

import '../../common/json/earning_json.dart';

class MyUpdateEarning extends StatefulWidget {
  MyUpdateEarning(){}
  @override
  _MyUpdateEarning createState() => _MyUpdateEarning();
}

class _MyUpdateEarning extends State<MyUpdateEarning> {
  List<String> keys = [];
  @override
  Widget build(BuildContext context) {
    keys = earningData.keys.toList();
    return   Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text('月工资收入', style: TextStyle(color: Colors.black, fontSize: 16)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(0.0),
        itemCount: keys.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int position) {
        return buildItemWidget(context, position);
        },
      ),
    );
  }

  Widget buildItemWidget(BuildContext context, int index) {
    return _buildItemWidget(context, index);
  }

  Widget _buildItemWidget(BuildContext context, int index) {
    return Container(
      child: ListTile(
          onTap: () {
            print("[earning on tap] value: ${earningData[keys[index]]!}");
            Map<String, dynamic> map = {"code": keys[index]};
            Navigator.of(context).pop<Map>(map);
            return;
          },
          title: Text(earningData[keys[index]]!),
          trailing: new Icon(Icons.keyboard_arrow_right)
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))
      ),
    );
  }
}
