/**
 * Created by NEU on 2017/6/7.
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
    var term=query(function () {/*
     select semester from arrangecourse where is_now="1"
     */}, context,"");
    context.term=term[0].semester;
    var result = query(function () {/*
      select manualadjustcourse.*,course.chineseName,FROM_UNIXTIME(UNIX_TIMESTAMP(manualadjustcourse.settime),'%Y-%m-%d %H:%i:%s') as settime,teacher.teacherName
      ,classroomName
      from manualadjustcourse
      inner join stuchoosecourse on manualadjustcourse.tc_id=stuchoosecourse.tc_id
      left join course on manualadjustcourse.courseId=course.courseId
      left join teacher on manualadjustcourse.now_teachName =teacher.teacherId
     left join classroom on classroom.classroomId=manualadjustcourse.now_room
     where stuchoosecourse.studentId=${studentId} and term=${term} AND iscomfirm=1 AND (scc_status!='退课通过' OR scc_status IS NULL)
     */},context,"");
    return {total:result.length,row:result};
}