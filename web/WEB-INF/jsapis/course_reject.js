/**
 * Created by NEU on 2017/4/19.
 */
function main(context) {
    //基础数据非空判断
    if(context.courseId == null){
        return false;
    }
    //判断驳回理由是否为空
    if(context.reason.trim() == ""){
        return false;
    }
    var result = exec(function () {/*
     UPDATE
     `course`
     SET
     `checkStatus` = "未通过",
     `refuseReason` = ${reason}
     WHERE `courseId` = ${courseId}
     */},context);
    return result;
}