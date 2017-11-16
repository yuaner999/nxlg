/**
 * Created by NEUNB_Lisy on 2017/5/16.
 */
function main(context){
    //基础数据非空判断
    if(context.tc_courseid == null||context.al_timeweek == null||context.al_timepitch == null||context.acId == null||context.classroomId == null
        ||context.classroomName == null||context.tc_id == null||context.al_Id == null){
        return false;
    }
    var con = createconnection();
    var result=multiexec(con,function(){/*
     UPDATE
     `arrangelesson`
     SET
     `courseId`=${tc_courseid},
     `al_code`=${al_code},
     `al_timeweek` = ${al_timeweek},
     `al_timepitch` = ${al_timepitch},
     `acId`=${acId},
     `classroomId` = ${classroomId},
     `classroomName`= ${classroomName},
     `tc_id` = ${tc_id}
     WHERE `al_Id` = ${al_Id}
     */},context);
    if(!result){
        rollback(con);
        closeconnection(con);
        return result;
    }
    commit(con);
    closeconnection(con);
    return result;
}

/*
var inputsamples=[
    {
        checkStatus:"已通过",
        courseCode:"6",
        courseId:"8e2ee4d7-8d1a-4046-9905-8e89affe6f9f"
    }
]*/
