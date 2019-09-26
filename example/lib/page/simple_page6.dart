import 'package:cached_network_image/cached_network_image.dart';
//import 'package:flutter/material.dart'
//    hide RefreshIndicator, RefreshIndicatorState;
//import 'package:flutter/scheduler.dart';
//import 'package:flutter_futrue_example/base_state.dart';
//import 'package:flutter_futrue_example/my/my_pro/my_proqress_view2.dart';
import 'package:flutter_futrue_example/net/bean/simple_bean.dart';
import 'package:flutter_futrue_example/net/net.dart';
import 'package:flutter_futrue_example/page/simple_page1_temp.dart';
//import 'package:flutter_futrue_example/util/comm_widgets.dart';
//import 'package:flutter_futrue_example/util/dialog_comm.dart';
//import 'package:pull_to_refresh/pull_to_refresh.dart';
//import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'dart:math';

import 'package:flutter_futrue/flutter_futrue.dart';

///
class SimplePage6 extends StatefulWidget {
  @override
  _SimplePage6State createState() => _SimplePage6State();
}

class _SimplePage6State extends BaseState<SimplePage6>
    with SingleTickerProviderStateMixin {
  var API_date10 = "http://www.mocky.io/v2/5d25615d2f00006400c10754"; //  十条数据
  var API_date3 = "http://www.mocky.io/v2/5d25892f2f00009136c10841"; // 三条数据
  var API_date0 = "http://www.mocky.io/v2/5d2596052f00000a35c108c7"; //数据为空
  var API_date900 = "http://www.mocky.io/v2/5d25968c2f00004834c108d1"; //登录失效
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
            WidgetHelper. appBarMenuText(
                title: '手刷',
                onPressed: () {
                  callInitLoading();
                  onRefresh();
                }),
        WidgetHelper. appBarMenuText(
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
    var path = randomPath('onRefresh');
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
          });
        },
        tokenInvalidCallback: () {
          print('这里是处理登出的逻辑，就退出当前页吧'); //临时
          Navigator.of(context).pop(); //临时
        });
  }

  void onLoading() async {
    var path = randomPath('onLoading');
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
          });
        },
        tokenInvalidCallback: () {
          print('这里是处理登出的逻辑，就退出当前页吧'); //临时
          Navigator.of(context).pop(); //临时
        });
  }

  Widget body() {
    return GridView.builder(
      padding: EdgeInsets.only(top: 2.0, left: 2.0, right: 2.0),
      itemCount: modelList.length,
      itemBuilder: (context, i) {
        var url = modelList[i].imageUrl;
        return new Material(
          elevation: 4.0,
          borderRadius: new BorderRadius.all(new Radius.circular(4.0)),
          child: new InkWell(
              onTap: () {

              },
              child:
              new Container(
                alignment: Alignment.center,
                child: CachedNetworkImage(imageUrl: url),
              )
          ),
        );
      },
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
        crossAxisCount: 2,
      ),
    );
  }

  ///模拟获取数据时的各种情况
  randomPath(who) {
    var random = Random().nextInt(6);
    print('$who，random = ${random} (0、4模拟10条、1模拟3条、2模拟0条、3模拟登录失效)');
    if (random == 0 || random == 4 || random == 5) {
      return API_date10;
    } else if (random == 1) {
      return API_date3;
    } else if (random == 2) {
      return API_date0;
    } else if (random == 3) {
      return API_date900;
    } //临时
  }
}
