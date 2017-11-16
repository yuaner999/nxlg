/**
 * Created by NEU on 2017/6/9.
 * 辅助排课--加载教室类型
 */
function main(context) {
    var result=query(function () {/*
      SELECT classroomId,classroomName
      FROM classroom
      WHERE classroomStatus='使用'
    */},context,"");
    return result;
}