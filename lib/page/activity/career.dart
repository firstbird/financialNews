import 'package:flutter/material.dart';

import '../../common/json/career_json.dart';

class ListViewCareer extends StatefulWidget {
  ListViewCareer(){}
  @override
  _ListViewCareer createState() => _ListViewCareer();
}

class _ListViewCareer extends State<ListViewCareer> {
  List<String> keys = [];
  @override
  Widget build(BuildContext context) {
    keys = careerData.keys.toList();
    return   Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 18),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text('您从事的职业', style: TextStyle(color: Colors.black, fontSize: 16)),
        centerTitle: true,
      ),
      body: ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(),
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
    // is header
    if (keys[index].endsWith("000")) {
      return ListTile(
        title: Text(careerData[keys[index]]!, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
      );
    } else {
      return
        Container(
        child: ListTile(
          onTap: (){
              print("[career on tap] value: ${careerData[keys[index]]!}");
              Map<String, dynamic> map = {"code":  keys[index]};
              Navigator.of(context).pop<Map>(map);
              return;

          },
          title: Text(careerData[keys[index]]!),
          // subtitle: Text(careerCategory[keys[index]]!),
          trailing: new Icon(Icons.keyboard_arrow_right)
        ),
        // decoration: BoxDecoration(
        //   border: Border(bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))
        // ),
      );
    }
  }
}
