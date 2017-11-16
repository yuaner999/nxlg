/**
 * Created by NEU on 2017/5/10.
 */
function main(context) {
    //基础数据非空判断
    if(context.majorIds.length <1){
        return false;
    }
    var con=createconnection();
    for(var i=0;i<context.majorIds.length;i++) {
        context.majorId = context.majorIds[i];
        var r = exec(function () {/*
         UPDATE
         `major`
         SET
         `scheduleTime` = ${node}
         WHERE majorId=${majorId}
         */}, context);
        if(!r){
            rollback(con);
            closeconnection(con);
            return false;
        }
    }
    commit(con);
    closeconnection(con);
    return true;
}