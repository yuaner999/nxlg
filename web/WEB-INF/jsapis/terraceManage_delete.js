/**
 * Created by NEU on 2017/4/18.
 */
function main(context) {
    //删除数据字典
    var con = createconnection();
    for(var i=0;i<context.deleteIds.length;i++){
        var deleteId = context.deleteIds[i];
        var result = multiexec(con,"delete from terrace where terraceId=${terraceId}",{terraceId:deleteId});
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