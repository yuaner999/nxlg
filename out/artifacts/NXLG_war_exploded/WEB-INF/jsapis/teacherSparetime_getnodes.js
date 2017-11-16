/**
 * Created by NEU on 2017/5/2.
 * 获取教师选课信息
 */
function main(context){
    var result=query(function(){/*
        select scheduleTime,nonscheduleTime,spareTime,mostClasses from teacher where teacherId=${teacherId}
    */},context,"");
    return result;
}