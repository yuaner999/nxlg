/**
 * Created by NEU on 2017/3/14.
 */
// 删除角色
function main(context) {
    var con = createconnection();
    for(var i=0;i<context.deleteIds.length;i++){
        var deleteId = context.deleteIds[i];
        var result = multiexec(con,"delete from role where roleId=${roleId}",{roleId:deleteId});
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
