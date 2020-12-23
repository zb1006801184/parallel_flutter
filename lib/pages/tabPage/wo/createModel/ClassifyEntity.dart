/// name : ""
/// id : 1
/// parentId : 1
/// level : 1

class ClassifyEntity {
  String name;
  int id;
  int parentId;
  int level;

  static ClassifyEntity fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ClassifyEntity classifyEntityBean = ClassifyEntity();
    classifyEntityBean.name = map['name'];
    classifyEntityBean.id = map['id'];
    classifyEntityBean.parentId = map['parentId'];
    classifyEntityBean.level = map['level'];
    return classifyEntityBean;
  }

  Map toJson() => {
    "name": name,
    "id": id,
    "parentId": parentId,
    "level": level,
  };
}