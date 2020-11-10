
class PageContentItemObject {
  final String itemName;
  final String itemContent;

  PageContentItemObject({
    this.itemName,
    this.itemContent});

  @override
  String toString() {
    return
      '{'
          ' ${this.itemName},'
          ' ${this.itemContent},'
        '}';
  }

  factory PageContentItemObject.fromJson(dynamic parsedJson){
    return PageContentItemObject(
      itemName: parsedJson['itemName'],
      itemContent: parsedJson['itemContent'],
    );
  }
}