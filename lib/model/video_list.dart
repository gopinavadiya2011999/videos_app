
import '../sqlite_db/database_helper.dart';

class VideoList{
  String? title;
  String? categoryImage;
  String? categoryName;
  String? videoLink;
  String? uploadTime;

  VideoList(
      {this.title, this.categoryImage, this.categoryName, this.videoLink});

  VideoList.fromMap(Map<String, dynamic> map) {
    title = map['title'];
    categoryImage = map['categoryImage'];
    categoryName = map['categoryName'];
    videoLink = map['videoLink'];
    uploadTime = map['uploadTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      DatabaseHelper.title: title,
      DatabaseHelper.categoryImage: categoryImage,
      DatabaseHelper.categoryName: categoryName,
      DatabaseHelper.videoLink: videoLink,
      DatabaseHelper.uploadTime: uploadTime
    };
  }
}

List<VideoList> videoList = [
  VideoList(
      videoLink: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',

      title: 'Song namesdssjjjjj will be here like this and dd song name will be here like this and Song name will be here like this.',
      categoryImage: 'assets/image1.jpg'
  ),  VideoList(
    videoLink:'https://media.w3.org/2010/05/sintel/trailer.mp4',
      title: 'Song name will be here like this and song name will be here like this and Song name will be here like this.',
      categoryImage: 'assets/image2.jpg'
  ), VideoList(
      videoLink: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',

      title: 'Song name will be here like this and song name will be here like this and Song name will be here like this.',
      categoryImage: 'assets/image3.jpg'
  ),
];