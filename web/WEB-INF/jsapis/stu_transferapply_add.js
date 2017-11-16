/**
 * Created by NEU on 2017/6/12.
 */
function main(context){
    //sessionUserID非空判断
    if(getsession(context,"sessionUserID") == null){
        return false;
    }
    var t=query(function () {/*
     SELECT
     `user`.*, `student`.*
     FROM `user`
     LEFT JOIN `student` ON (`user`.`typeId` = `student`.`studentId`)
     WHERE `user`.`typeName`="学生" AND `user`.`userId`=${sessionUserID}
     */}, context,"");
    if(t.length>0){
        context.studentId=t[0].studentId;
        context.studentMajor=t[0].studentMajor;
        context.otherMajor=t[0].otherMajor;
    }else{
        return{result:false,errormessage:'没有查到您的信息'}
    }
    var term=query(function () {/*
     select semester from arrangecourse where is_now='1'
     */}, context,"");
    context.term=term[0].semester;
    var q= query(function () {/*
     SELECT *
     FROM transferapply
     WHERE term=${term} and studentId=${studentId}
     */},context,"");
    if(q.length>0) return{result:false,errormessage:'本学期已经有调剂课程申请了,请修改课程调剂申请'};
    var result=exec(function(){/*
     INSERT INTO `nxlg`.`transferapply` ( `transferid`,`studentId`,`term`,`studentMajor`,`otherMajor`,
     `reason`, `setdate`, `status`)
     VALUES (uuid(),${studentId},${term},${studentMajor},${otherMajor},${reason},NOW(),'待审核') ;
     */},context);
    return{result:result,errormessage:''}
}

