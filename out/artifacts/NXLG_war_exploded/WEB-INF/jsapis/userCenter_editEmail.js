/**
 * Created by NEU on 2017/4/14.
 */
function main(context) {
    //数据非空判断
    if(context.newemail == null){
        return false;
    }
    //修改学生、用户信息
    if(context.typeName=="学生"){
        var r = exec(function(){/*
         UPDATE `student` SET `studentEmail` = ${newemail}
         WHERE `studentId` = ${studentId};
         UPDATE `user` SET `userEmail` = ${newemail}
         WHERE `typeId` = ${studentId};
         */}, context);
        if(r){
            return {result:r};
        }else {
            return {result:false,errormessage:"修改失败"};
        }
    }else if(context.typeName=="教师"){
        var r = exec(function(){/*
         UPDATE `teacher` SET `email` = ${newemail}
         WHERE `teacherId` = ${teacherId};
         UPDATE `user` SET `userEmail` = ${newemail}
         WHERE `typeId` = ${teacherId};
         */}, context);
        if(r){
            return {result:r};
        }else {
            return {result:false,errormessage:"修改失败"};
        }
    }else if(context.typeName=="管理员"){
        var r = exec(function(){/*
         UPDATE `admin` SET `adminEmail` = ${newemail}
         WHERE `adminId` = ${adminId};
         UPDATE `user` SET `userEmail` = ${newemail}
         WHERE `typeId` = ${adminId};
         */}, context);
        if(r){
            return {result:r};
        }else {
            return {result:false,errormessage:"修改失败"};
        }
    }
}