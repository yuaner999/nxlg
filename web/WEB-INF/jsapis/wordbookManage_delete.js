/**
 * Created by c on 2017/3/15.
 */
function main(context) {
    //删除数据字典
    var con = createconnection();
    for(var i=0;i<context.deleteIds.length;i++){
        var deleteId = context.deleteIds[i];
        var result = multiexec(con,"delete from wordbook where wordbookId=${wordbookId}",{wordbookId:deleteId});
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