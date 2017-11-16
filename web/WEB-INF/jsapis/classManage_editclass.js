/**
 * Created by gq on 2017/6/1.
 */
function main(context) {
    //基础数据非空判断
    if(context.classId == null||context.gradeName == null||context.className == null){
        return false;
    }
    //sessionUserName非空判断
    if(getsession(context,"sessionUserName")==null){
        return false;
    }
    var q2= query(function () {/*
     SELECT *
     FROM class
     WHERE gradeName=${gradeName} and className=${className}
     */},context,"");
    if(q2 && q2.length>0) return{result:false,errormessage:'要修改的班级名称已存在'}

    var up = exec(function(){/*
     UPDATE  `class`
     SET
     `className` = ${className},
     `gradeName` = ${gradeName},
     `updateMan` = ${sessionUserName},
     `updateDate` = now()
     WHERE `classId` = ${classId} ;
     */}, context);
    if (!up) {return{result:false,errormessage:''}};
    return {result:true,errormessage:''};
}
