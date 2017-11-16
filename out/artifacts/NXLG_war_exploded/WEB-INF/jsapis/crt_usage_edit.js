/**
 * Created by NEUNB_Lisy on 2017/5/24.
 */
function main(context){
    //基础数据非空判断
    if(context.crt_usage == null||context.crt_id == null){
        return false;
    }
    if(isNaN(context.crt_usage)){
        return false;
    }
    var con = createconnection();
    var result=multiexec(con,function(){/*
     UPDATE
     `classroomtype`
     SET
     `crt_usage`=${crt_usage}
     WHERE
     crt_id=${crt_id}
     */},context);
    if(!result){
        rollback(con);
        closeconnection(con);
        return result;
    }
    commit(con);
    closeconnection(con);
    return result;
}