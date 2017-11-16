/**
 * Created by NEU on 2017/4/20.
 */
function main(context){
    //sessionUserID非空判断
    if(getsession(context,"sessionUserID") == null){
        return false;
    }
    //基础数据非空判断
    if(context.majorCollege == null ||context.majorName == null){
        return false;
    }
    //换专业
    var rr = query(function () {/*
     SELECT
     `user`.*, `student`.*
     FROM `user`
     LEFT JOIN `student` ON (`user`.`typeId` = `student`.`studentId`)
     WHERE `user`.`typeName`="学生" AND `user`.`userId`=${sessionUserID}
     */},context,"");
    console(rr);
    if(!rr){
        return false;
    }
    context.studentId=rr[0].studentId;
    context.major=rr[0].studentMajor;
    var r3 = query(function () {/*
     SELECT * FROM `major` WHERE majorName=${majorName}
     */},context,"");
    if(!r3){
        return false;
    }
    context.majorCollege=r3[0].majorCollege;
    var con = createconnection();
    if(context.major == context.majorName){
        rollback(con);
        closeconnection(con);
        return {message:"选修专业就是该专业，无需重复选修"}
    }
    
    var result=multiexec(con,function(){/*
     UPDATE `student` 
     SET
      studentCollege=${majorCollege},
     `studentMajor` =${majorName}
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
     `beforeMajor`,
     `afterMajor`,
     `time`
     )
     VALUES
     (
     UUID(),
     ${studentId},
     "选修",
     ${major},
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