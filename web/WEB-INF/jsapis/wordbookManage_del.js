/**
 * Created by NEU on 2017/3/15.
 */
function main(context) {
    //删除数据字典
    var con = createconnection();
    var result = multiexec(con,"delete from wordbook where wordbookId=${wordbookId}",context);
    if(!result){
        rollback(con);
        closeconnection(con)
        return false;
    }
    commit(con);
    closeconnection(con);
    return true;
}