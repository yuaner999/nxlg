/**
 * Created by NEU on 2017/4/25.
 */
// 删除学生信息
function main(context){
    var con=createconnection();
    var  result=multiexec(con,"delete from student where studentId=${studentId}",context);
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
    commit(con);
    closeconnection(con);
    return true;
}