/**
 * Created by NEU on 2017/5/20.
 * 是否这学期这个平台已经确认调剂了
 * 提交了的话，istiaojicomfirm=1
 */
function main(context) {
    var t=query(function () {/*
     SELECT
     `user`.*, `student`.*
     FROM `user`
     LEFT JOIN `student` ON (`user`.`typeId` = `student`.`studentId`)
     WHERE `user`.`typeName`="学生" AND `user`.`userId`=${sessionUserID}
     */}, context,"");
    context.studentId=t[0].studentId;
    var term=query(function () {/*
     select semester from arrangecourse where is_now='1'
     */}, context,"");
    context.term=term[0].semester;
    // 这个人cantiaoji='1'
    var r=query(function () {/*
     SELECT cantiaoji,tiaojiterm
     FROM `nxlg`.`student`
     where student.studentId=${studentId} and tiaojiterm=${term} and cantiaoji='1'
     */}, context,"");
    return {total:r.length,rows:r};
}
