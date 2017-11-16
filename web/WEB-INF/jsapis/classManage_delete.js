/**
 * Created by gq on 2017/6/1.
 */
function main(context) {
    //删除班级
    var con = createconnection();
    console(context.deleteIds)
    for(var i=0;i<context.deleteIds.length;i++){
        var deleteId = context.deleteIds[i];
        var result = multiexec(con,"delete from class where classId=${tmId}",{tmId:deleteId});
        if(!result){
            rollback(con);
            closeconnection(con);
            return false;
        }
    }
    commit(con);
    closeconnection(con);
    return true;
}
