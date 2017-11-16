/**
 * Created by zcy on 2017/5/26.
 * 批量设置使用备用/首选教材
 */
function main(context) {
    //数据非空判断
    if(context.courseIds.length < 1){
        return false;
    }
    var con=createconnection();
    if(context.id==1){
        for(var i=0;i<context.courseIds.length;i++){
            context.courseId=context.courseIds[i];
            var result = exec(function () {/*
             update course
             set issparecourse='1'
             where courseId=${courseId}
             */},context,"");
            if(!result){
                rollback(con);
                closeconnection(con);
                return false;
            }
        }
    }else if(context.id==2){
        for(var i=0;i<context.courseIds.length;i++){
            context.courseId=context.courseIds[i];
            var result = exec(function () {/*
             update course
             set issparecourse='0'
             where courseId=${courseId}
             */},context,"");
            if(!result){
                rollback(con);
                closeconnection(con);
                return false;
            }
        }
    }
    commit(con);
    closeconnection(con);
    return true;
}