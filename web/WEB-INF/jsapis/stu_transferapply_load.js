/**
 * Created by NEU on 2017/6/12.
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
    var n= querypagedata(function () {/*
     select *,FROM_UNIXTIME(UNIX_TIMESTAMP(setdate),'%Y-%m-%d %H:%i:%s') AS setdate from transferapply
     where studentId=${studentId}
     order by setdate desc
     */},context,"",context.pageNum,context.pageSize);
    return n;
}