/**
 * Created by NEU on 2017/4/25.
 */
function main(context){
   var con=createconnection();
    var  result=multiexec(con,"delete from classroom where classroomId=${classroomId}",context);
    if(!result){
        rollback(con);
        closeconnection(con)
        return false;
    }
    commit(con);
    closeconnection(con);
    return true;
}
