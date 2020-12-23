///小编页面的机器人数据实体类
class MyRobotEntity {
  bool createButton; //是否为创建机器人按钮
  String name;
  String iconAssets;
  String iconUrl;
  bool lock;

  MyRobotEntity(this.name,
      {this.iconUrl, this.iconAssets, lock = false, createButton = false}) {
    this.lock = lock;
    this.createButton = createButton;
  }

  @override
  String toString() {
    return 'MyRobotEntity{createButton: $createButton, name: $name, iconAssets: $iconAssets, iconUrl: $iconUrl, lock: $lock}';
  }
}
