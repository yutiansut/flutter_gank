import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

///刷新本地数据库
class RefreshDBEvent {}

///切换福利列数
class ChangeFuliColumnEvent{}

///根据日期更新首页数据
class RefreshNewPageEvent{
  String date;
  RefreshNewPageEvent(this.date);
}