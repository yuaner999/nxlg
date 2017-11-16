/**
 * Created by zqy on 2017/8/23.
 */
function main(context) {
    //获取用户信息
    var userInfo= query(function () {/*
         SELECT `user`.`userId`,`user`.`typeId`,`user`.`typeName`  FROM `user`
         WHERE `user`.`userId`=${sessionUserID}
    */},context,"");
    context.typeId = userInfo[0].typeId;
    if(userInfo){
        if(userInfo[0].typeName=="学生"){
            return studentEditImage(context);
        }else if(userInfo[0].typeName=="教师"){
            return  teacherEditImage(context);
        }else if(userInfo[0].typeName=="管理员"){
            return  adminEditImage(context);
        }else{
            return {result:false,message:"管理员未给该用户分配用户类型"};
        }
    }else{
        return {result:false,message:"请从新登录"};
    }

}

function  adminEditImage(context) {
    var result=exec(function(){/*
     UPDATE `admin` SET `admin`.`adminIcon` = ${img_id},`admin`.`updateMan` = ${sessionUserID},`admin`.`updateDate` = NOW() WHERE `admin`.`adminId` = ${typeId}
    */},context);
    if(result){
        return {result:result};
    }else{
        return {result:false,message:"更新失败"};
    }
}

function studentEditImage(context) {
    var result=exec(function(){/*
     UPDATE `student` SET `student`.`studentIcon` = ${img_id} WHERE `student`.`studentId` = ${typeId}
    */},context);
    if(result){
        return {result:result};
    }else{
        return {result:false,message:"更新失败"};
    }
}

function  teacherEditImage(context) {
    var result=exec(function(){/*
     UPDATE `teacher` SET `teacher`.`teacherIcon` = ${img_id} WHERE `teacher`.`teacherId` =  ${typeId}
    */},context);
    if(result){
        return {result:result};
    }else{
        return {result:false,message:"更新失败"};
    }
}