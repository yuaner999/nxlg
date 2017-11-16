/**
 * Created by gq on 2017/5/27.
 * 删除学院
 */
function main(context) {
    //删除信息
    var con = createconnection();
    for(var i=0;i<context.deleteIds.length;i++){
        var deleteId = context.deleteIds[i];
        var wordbook = context.wordbookValue[i];
        var result = multiexec(con,"delete from wordbook where wordbookId=${tmId}",{tmId:deleteId});
        if(!result){
            rollback(con);
            closeconnection(con)
            return false;
        }
        var r = multiexec(con,"delete from educateplane where ep_college=${tmId}",{tmId:wordbook});
        if(!r){
            rollback(con);
            closeconnection(con)
            return false;
        }
    }
    commit(con);
    closeconnection(con);
    return true;
}