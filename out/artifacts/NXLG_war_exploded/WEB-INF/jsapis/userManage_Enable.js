/**
 * Created by NEU on 2017/3/14.
 */
//启用用户
function main(context) {
    //数据非空判断
    if(context.enableIds.length < 1){
        return false;
    }
    var con = createconnection();
    for(var i=0;i<context.enableIds.length;i++){
        var enableId = context.enableIds[i];
        var result = multiexec(con,"update user set userStatus='启用' where userId=${userId}",{userId:enableId});
        if(!result){
            rollback(con);
            closeconnection(con)
            return false;
        }
    }1
    commit(con);
    closeconnection(con);
    return true;
}