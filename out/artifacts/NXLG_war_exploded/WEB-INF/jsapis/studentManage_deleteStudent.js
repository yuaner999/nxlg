/**
 * Created by NEU on 2017/3/16.
 */
// 删除学生信息
function main(context){
    var con=createconnection();
    for(var i=0;i<context.deleteIds.length;i++){
        var deleteId=context.deleteIds[i];
        var  result=multiexec(con,"delete from student where studentId=${studentId}",{studentId: deleteId});
        if(!result){
            rollback(con);
            closeconnection(con)
            return false;
        }
        var  r=multiexec(con,"DELETE FROM user WHERE typeId=${studentId}",context);
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