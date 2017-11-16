/**
 * Created by NEU on 2017/5/15.
 */
function main(context) {
    //基础数据非空判断
    if(context.courseIds.length <= 0){
        return false;
    }
    for(var i=0;i<context.courseIds.length;i++) {
        context.courseId = context.courseIds[i];
        var r = exec(function () {/*
         UPDATE
         `course`
         SET
         `scheduleTime` = ${node},
         `nonscheduleTime` = ${node1}
         WHERE courseId=${courseId}
         */}, context);
        if(!r){
            return false;
        }
    }
    return true;
}