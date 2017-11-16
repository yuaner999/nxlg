/**
 * Created by NEUNB_Lisy on 2017/5/24.
 */
function main(context){
    var con=createconnection();
    var  result=multiexec(con,"delete from classroomtype where crt_id=${crt_id}",context);
    if(!result){
        rollback(con);
        closeconnection(con)
        return false;
    };
    commit(con);
    closeconnection(con);
    return true;
}