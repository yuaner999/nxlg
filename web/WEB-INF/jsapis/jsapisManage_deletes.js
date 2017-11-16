/**
 * Created by NEUNB_Lisy on 2017/7/31.
 */
function main(context) {
    //批量删除接口功能
    var con = createconnection();
    for (var i = 0; i<context.deleteIds.length;i++){
        var deleteId = context.deleteIds[i];
        var result = multiexec(con,"DELETE FROM menu_jsapi WHERE mj_id=${mj_id}",{mj_id:deleteId});
        if (!result){
            rollback(con);
            closeconnection(con);
            return false;
        }
    }
    commit(con);
    closeconnection(con);
    return true;
}