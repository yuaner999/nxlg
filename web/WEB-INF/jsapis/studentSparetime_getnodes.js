/**
 * Created by NEU on 2017/5/10.
 * 获取学生选课信息
 */
function main(context){
    var result=query(function(){/*
     select scheduleTime from major where majorId=${majorId}
     */},context,"");
    return result;
}