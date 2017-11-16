/**
 * Created by NEU on 2017/3/16.
 */
function main(context){
   var con=createconnection();
    for(var i=0;i<context.deleteIds.length;i++){
        var deleteId=context.deleteIds[i];
        var  result=multiexec(con,"delete from classroom where classroomId=${classroomId}",{classroomId:deleteId});
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
