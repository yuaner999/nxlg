/**
 * Created by NEU on 2017/4/21.
 */
function main(context) {
    //删除教材信息
    var con = createconnection();
    for(var i=0;i<context.deleteIds.length;i++){
        var deleteId = context.deleteIds[i];
        var result = multiexec(con,"update teachingmaterials set isdelete='1' where tmId=${tmId}",{tmId:deleteId});
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