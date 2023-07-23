import 'package:flutter/material.dart';

import '../../common/json/education_json.dart';

class ListViewEducation extends StatefulWidget {
  ListViewEducation(){}
  @override
  _ListViewEducation createState() => _ListViewEducation();
}

class _ListViewEducation extends State<ListViewEducation> {
  List<String> keys = [];
  @override
  Widget build(BuildContext context) {
    keys = educationData.keys.toList();
    return   Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text('您的学历', style: TextStyle(color: Colors.black, fontSize: 16)),
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
            print("[education on tap] value: ${educationData[keys[index]]!}");
            Map<String, dynamic> map = {"code": keys[index]};
            Navigator.of(context).pop<Map>(map);
            return;
          },
          title: Text(educationData[keys[index]]!),
          trailing: new Icon(Icons.keyboard_arrow_right)
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))
      ),
    );
  }
}
