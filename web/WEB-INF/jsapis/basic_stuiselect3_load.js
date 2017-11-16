/**
 * Created by NEU on 2017/5/22.
 */
function main(context) {
    var r= query(function () {/*
     SELECT `user`.*, `student`.*   FROM `user`
     LEFT JOIN `student` ON (`user`.`typeId` = `student`.`studentId`)
     WHERE `user`.`typeName`="学生" AND `user`.`userId`=${sessionUserID}
     */},context,"");
    context.studentId=r[0].studentId;
    var semester=query(function () {/*
     select semester from arrangecourse where is_now="1"
     */}, context,"");
    context.term=semester[0].semester;
    var t= query(function () {/*
     select * from stuchoosecourse
     where studentId=${studentId} and courseId=${courseId} and class=${tc_class} and terraceId=${terraceId} and term=${term} and iscomfirm='2'
     and majorId=${majorId}
     */},context,"");
    return {total: t.length,rows:t};
}
var inputsamples=[{
    sessionUserID:'b69d5e95-3a1d-11e7-b0f2-00ac9c2c0afa',
    courseId:'1597f967-5bd6-4ca8-8fd7-95ad688970f3',
    terraceId:'c31347a8-96f3-43df-9c69-2372b7978dce',
    tc_class:'英语1班'
}]