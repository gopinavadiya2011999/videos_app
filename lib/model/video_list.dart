


class VideoList{
  String? title;
  String? videoId;
  String? categoryImage;
  String? videoLink;
  String? uploadTime;
  String? videoThumbnail;
  bool delete=false;
  bool checkbox=false;


  VideoList(
      {this.title,
      this.videoId,
        this.delete=false,
        this.checkbox=false,
      this.categoryImage,
      this.videoLink,
      this.uploadTime,
      this.videoThumbnail});




}

