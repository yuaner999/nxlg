/**
 * Created by NEU on 2017/3/18.
 */
function main(context){
    // 删除教师信息
    var con=createconnection();
    for(var i=0;i<context.deleteIds.length;i++){
        var deleteId=context.deleteIds[i];
        var  result=multiexec(con,"delete from teacher where teacherId=${teacherId}",{teacherId: deleteId});
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