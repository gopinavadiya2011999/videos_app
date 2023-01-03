
class CategoryModel {
  String? categoryId;
  String? categoryName;
  String? categoryImage;
  String? updateTime;
  bool delete=false;

  CategoryModel({this.delete=false,this.categoryId, this.categoryName, this.categoryImage,this.updateTime});

}

