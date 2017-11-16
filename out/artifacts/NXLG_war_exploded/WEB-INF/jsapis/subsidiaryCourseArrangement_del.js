/**
 * Created by NEUNB_Lisy on 2017/5/16.
 */
function main(context){
    //删除
    var con = createconnection();
    var result = multiexec(con,"delete from arrangelesson where al_Id=${al_Id}",context);
    if(!result){
        rollback(con);
        closeconnection(con);
        return result;
    };
    commit(con);
    closeconnection(con);
    return result;
}
