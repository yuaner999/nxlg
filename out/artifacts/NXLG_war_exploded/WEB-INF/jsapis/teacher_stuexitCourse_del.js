/**
 * Created by NEU on 2017/4/18.
 */
function main(context){
    var t=query(function () {/*
     SELECT
     `user`.*, `student`.*
     FROM `user`
     LEFT JOIN `student` ON (`user`.`typeId` = `student`.`studentId`)
     WHERE `user`.`typeName`="学生" AND `user`.`userId`=${sessionUserID}
     */}, context,"");
    context.studentId=t[0].studentId;
    var result=exec(function(){/*
     delete from stuchoosecourse where studentId=${studentId} and  courseId=${courseId} and terraceId=${terraceId} and class=${tc_class}
     and majorId=${majorId}
     */},context);
    return result;
}
