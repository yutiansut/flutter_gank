import 'package:event_bus/event_bus.dart';
import 'package:flutter_gank/model/user_model.dart';

EventBus eventBus = EventBus();

///刷新本地数据库
class RefreshDBEvent {}

///切换福利列数
class ChangeFuliColumnEvent {}

///登录成功
class LoginEvent {
  User user;

  LoginEvent(this.user);
}

///登出成功
class LogOutEvent {}

///根据日期更新首页数据
class RefreshNewPageEvent {
  String date;

  RefreshNewPageEvent(this.date);
}
