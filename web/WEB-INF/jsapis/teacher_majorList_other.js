/**
 * Created by NEU on 2017/4/20.
 */
function main(context){
    //sessionUserID非空判断
    if(getsession(context,"sessionUserID") == null){
        return false;
    }
    //基础数据非空判断
    if(context.majorName == null){
        return false;
    }
    //辅修专业
    var rr = query(function () {/*
     SELECT
     `user`.*, `student`.*
     FROM `user`
     LEFT JOIN `student` ON (`user`.`typeId` = `student`.`studentId`)
     WHERE `user`.`typeName`="学生" AND `user`.`userId`=${sessionUserID}
     */},context,"");
    if(!rr){
        return false;
    }
    context.studentId=rr[0].studentId;
    context.major=rr[0].otherMajor;
    var stuMajor = rr[0].studentMajor;
    var con = createconnection();
    if(context.majorName == stuMajor){
        rollback(con);
        closeconnection(con);
        return {message:"该专业是您的主修专业，请选择其他专业辅修！"}
    }
    if(context.major == context.majorName){
        rollback(con);
        closeconnection(con);
        return {message:"辅修专业就是该专业，无需重复选择！"}
    }
    var result=multiexec(con,function(){/*
     UPDATE `student` 
     SET
     `otherMajor` =${majorName}
     WHERE `studentId` = ${studentId};
     */},context);
    if(!result){
        rollback(con);
        closeconnection(con);
        return false;
    }
    var r=multiexec(con,function(){/*
     INSERT INTO `stumajorrecord` (
     `id`,
     `studentId`,
     `type`,
     `otherMajor`,
     `time`
     )
     VALUES
     (
     UUID(),
     ${studentId},
     "辅修",
     ${majorName},
     NOW()
     ) 
     */},context);
    if(!r){
        rollback(con);
        closeconnection(con);
        return false;
    }
    commit(con);
    closeconnection(con);
    return true;
}