/**
 * Created by liulei on 2017-03-04.
 */
function main(context) {
    var con = createconnection();
    for(var i=0;i<context.deleteIds.length;i++){
        var deleteId = context.deleteIds[i];
        var result = multiexec(con,"delete from menu where menuId=${menuId}",{menuId:deleteId});
        if(!result){
            rollback(con);
            closeconnection(con);
            return false;
        }
        var r = multiexec(con,"delete from role_menu where menuId=${menuId}",{menuId:deleteId});
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