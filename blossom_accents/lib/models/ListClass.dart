class ListClass {
  String header;
  int wordCount;
  String userId;
  String listId;
  String authorName;

  ListClass(String header,String userId,int wordCount,String userName,String listId){
    this.header=header;
    this.userId=userId;
    this.wordCount=wordCount;
    this.listId=listId;
    this.authorName=userName==null?"还没取名字":userName;
    this.listId=listId;
  }
}