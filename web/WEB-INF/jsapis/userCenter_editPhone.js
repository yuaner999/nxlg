/**
 * Created by NEU on 2017/4/14.
 */
function main(context) {
    //数据非空判断
    if(context.newphone == null){
        return false;
    }
    //修改学生、用户信息 
    if(context.typeName=="学生"){
        var result =exec(function () {/*
         UPDATE
         `student`
         SET
         `studentPhone` = ${newphone}
         WHERE `studentId` = ${studentId}
         */},context);
        if(result){
            return {result:result};
        }else {
            return {result:false,errormessage:"修改失败"};
        }
    }else if(context.typeName=="教师"){
        var result =exec(function () {/*
         UPDATE
         `teacher`
         SET
         `phone` = ${newphone}
         WHERE `teacherId` = ${teacherId}
         */},context);
        if(result){
            return {result:result};
        }else {
            return {result:false,errormessage:"修改失败"};
        }
    }else if(context.typeName=="管理员"){
        var result =exec(function () {/*
         UPDATE
         `admin`
         SET
         `adminPhone` = ${newphone}
         WHERE `adminId` = ${adminId}
         */},context);
        if(result){
            return {result:result};
        }else {
            return {result:false,errormessage:"修改失败"};
        }
    }

}