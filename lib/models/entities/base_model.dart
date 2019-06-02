abstract class BaseModel {
  dynamic getAttribute(int key);

  Map<String, dynamic> toMap();
}

int convertInt(dynamic item) => (item != null && item != 'null')
    ? item.runtimeType == int ? item : int.parse(item)
    : null;

DateTime convertDateTime(dynamic item) => (item != null && item != 'null')
    ? item.runtimeType == DateTime ? item : DateTime.parse(item)
    : null;

bool convertBool(dynamic item) => (item != null && item != 'null')
    ? item.runtimeType == bool ? item : (item == 'true' ? true : false)
    : null;
