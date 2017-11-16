/**
 * Created by NEUNB_Lisy on 2017/5/16.
 */
function main(context){
    //基础数据非空判断
    if(context.tc_courseid == null||context.al_timeweek == null||context.al_timepitch == null||context.acId == null||context.classroomId == null
        ||context.classroomName == null||context.tc_id == null){
        return false;
    }
    var result=exec(function(){/*
     INSERT INTO `arrangelesson` (
     `al_Id`,
     `courseId`,
     `al_timeweek`,
     `al_timepitch`,
     `acId`,
     `classroomId`,
     `classroomName`,
     `tc_id`
     )
     VALUES
     (
     uuid(),
     ${tc_courseid},
     ${al_timeweek},
     ${al_timepitch},
     ${acId},
     ${classroomId},
     ${classroomName},
     ${tc_id}
     )
     */},context);
    return result;
}