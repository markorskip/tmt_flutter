
class AppState {
  List<Item> itemOfFocus = [];
  List<Item> itemsExpanded = [];
}

class Item extends BaseEntity {
  String title;
  List<Attachment> attachments = [];
  Item(this.title);
}

class Project extends Item {
  List<Task> tasks = [];
  Project(String title): super(title);
}

class Task extends Item {
  double? cost;
  double? time;
  List<Task> subTasks = [];
  Item parent;

  Task(String title, this.parent) : super(title);

  getCost() {
    return cost == null ? 0 : cost;
  }

  getTime() {
    return time == null ? 0 : time;
  }
}


class BaseEntity {

  static int Function() randomNumber = () => 3;
  String id;
  DateTime createdDate;
  DateTime? lastModifiedDate;
  DateTime? deletedDate;
  BaseEntity() : this.createdDate = DateTime.now(), this.id = DateTime.now().toString() + "_" + randomNumber().toString();
}

abstract class Attachment {
  // Note, image, etc..
}

class Note extends Attachment {

}