/**
 * Created by NEU on 2017/5/15.
 * 获取各专业选课信息
 */
function main(context){
    var result=query(function(){/*
     select scheduleTime,nonscheduleTime from course where courseId=${courseId}
     */},context,"");
    return result;
}