/**
 * Created by NEU on 2017/6/12.
 */
function main(context) {
    //基础数据非空判断
    if(context.passIds.length <= 0){
        return false;
    }
    var con = createconnection();
    //遍历所有的数据
    for (var i = 0; i < context.passIds.length; i++) {
        var transferid = context.passIds[i].transferid;//申请调剂的ID
        var result = multiexec(con, function () {/*
         update transferapply set status='已通过',reject='' where transferid=${transferid};
         */}, {transferid: transferid});
        if (!result) {//出错回滚
            rollback(con);
            closeconnection(con)
            return false;
        }
    }
    commit(con);//提交
    closeconnection(con);//关闭连接
    return true;
}