


class VideoList{
  String? title;
  String? videoId;
  String? categoryImage;
  String? categoryName;
  String? videoLink;
  String? uploadTime;
  String? videoThumbnail;
  bool delete=false;


  VideoList(
      {this.title,
      this.videoId,
        this.delete=false,
      this.categoryImage,
      this.categoryName,
      this.videoLink,
      this.uploadTime,
      this.videoThumbnail});




}

