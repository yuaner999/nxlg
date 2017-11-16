/**
 * Created by gq on 2017/6/1.
 */
function main(context){
    //基础数据非空判断
    if(context.gradeName == null||context.className == null){
        return false;
    }
    var className = context.className.replace(/\s+/g,"");
    var gradeName = context.gradeName;
    //sessionUserName非空判断
    if(getsession(context,"sessionUserName")==null){
        return false;
    }
    var q= query(function () {/*
     SELECT *
     FROM class
     WHERE gradeName=${gradeName} and className=${className}
     */},{gradeName:gradeName,className:className},"");

    if(q && q.length>0) return{result:false,errormessage:'已经存在该班级名称，不能重复新建'}
    var result=exec(function(){/*
     INSERT INTO  `class` (`classId`, `className`,`gradeName`,`createMan`,`createDate`)
     VALUES ( uuid(),${className},${gradeName},${sessionUserName},now())
     */},context);
     return{result:result,errormessage:''}
}
