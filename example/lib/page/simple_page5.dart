import 'package:flutter_futrue_example/net/bean/simple_bean.dart';
import 'package:flutter_futrue_example/net/net.dart';
import 'package:flutter_futrue_example/page/simple_page1_temp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_futrue_example/net/api.dart';
import 'package:flutter_futrue/flutter_futrue.dart';

///
class SimplePage5 extends StatefulWidget {
  @override
  _SimplePage5State createState() => _SimplePage5State();
}

class _SimplePage5State extends BaseState<SimplePage5>
    with SingleTickerProviderStateMixin {
  List<SimpleDataBean> modelList = [];
  bool isPrint = true;

  @override
  void initState() {
    onRefresh();
    super.initState();
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('随机模拟所有情况'),
          actions: <Widget>[
            WidgetHelper.appBarMenuText(
                title: '手刷',
                onPressed: () {
                  callInitLoading();
                  onRefresh();
                }),
            WidgetHelper.appBarMenuText(
                title: '去页面-返刷新',
                onPressed: () {
                  RouteHelper.pushResultWidget(context, new SimplePage1Temp())
                      .then((result) {
                    print('result = ${result.toString()}');
                    callInitLoading();
                    onRefresh();
                  });
                }),
          ],
        ),
        body: bodyWidget(
          modelList: modelList,
          onRefresh: onRefresh,
          onLoading: onLoading,
          contentBody: body(),
        ));
  }

  void onRefresh() async {
    var path = Api.randomPath('onRefresh');
    callRefresh(
        modelList: modelList,
        dao: HttpManager().get(
          who: 'path',
          path: path,
        ),
        dataCallback: (Object bean) {
          List<dynamic> temp = bean;
          temp.length >= 10 ? isLoading = true : isLoading = false;
          temp.forEach((v) {
            modelList.add(new SimpleDataBean.fromJson(v));
          });     setState(() {});
        },
        tokenInvalidCallback: () {
          print('这里是处理登出的逻辑，就退出当前页吧'); //临时
          Navigator.of(context).pop(); //临时
        });
  }

  void onLoading() async {
    var path = Api.randomPath('onLoading');
    callLoading(
        dao: HttpManager().get(
          who: path,
          path: path,
        ),
        dataCallback: (bean) {
          List<dynamic> temp = bean;
          temp.length >= 10 ? isLoading = true : isLoading = false;
//          callLoadingCheck(temp.length);
          temp.forEach((v) {
            modelList.add(new SimpleDataBean.fromJson(v));
          });     setState(() {});
        },
        tokenInvalidCallback: () {
          print('这里是处理登出的逻辑，就退出当前页吧'); //临时
          Navigator.of(context).pop(); //临时
        });
  }

  Widget body() {
    return ListView.builder(
      itemCount: modelList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
            alignment: Alignment.center,
            height: 80.0,
            child: Column(
              children: <Widget>[
                Text('${modelList[index].name}'),
                TextField(
                  decoration: InputDecoration(
                      labelText: "请输入内容",
                      filled: true,
                      fillColor: Colors.grey.shade50),
                ),
              ],
            ));
      },
    );
  }
}
