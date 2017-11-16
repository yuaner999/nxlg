/**
 * Created by NEU on 2017/4/26.
 * 删除空教室
 */
function main(context) {
    var con = createconnection();
    for(var i=0;i<context.deleteIds.length;i++){
        var deleteId = context.deleteIds[i];
        var result = multiexec(con,"delete from spareclassroom where scId=${scId}",{scId:deleteId});
        if(!result){
            rollback(con);
            closeconnection(con)
            return false;
        }
    }
    commit(con);
    closeconnection(con);
    return true;
}