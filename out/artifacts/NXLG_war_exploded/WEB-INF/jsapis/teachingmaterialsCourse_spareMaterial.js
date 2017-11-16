/**
 * Created by zcy on 2017/6/2.
 * 设置使用备用教材
 */
function main(context) {
    //数据非空判断
    if(context.courseId == null){
        return false;
    }
    if(context.id==1){
        var result=exec(function () {/*
         update course
         set issparecourse='1'
         where courseId=${courseId}
         */},context,"");
        return result;
    }else if(context.id==2){
        var r=exec(function () {/*
         update course
         set issparecourse='0'
         where courseId=${courseId}
         */},context,"");
        return r;
    }


}