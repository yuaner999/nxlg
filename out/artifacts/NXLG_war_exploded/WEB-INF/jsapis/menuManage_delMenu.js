/**
 * Created by NEU on 2017-04-25.
 */
function main(context) {
    var con = createconnection();
    var result = multiexec(con,"delete from menu where menuId=${menuId}",context);
    if(!result){
        rollback(con);
        closeconnection(con);
        return false;
    }
    var r = multiexec(con,"delete from role_menu where menuId=${menuId}",context);
    if(!r){
        rollback(con);
        closeconnection(con);
        return false;
    }
    commit(con);
    closeconnection(con);
    return true;
}