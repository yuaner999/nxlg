/**
 * Created by NEU on 2017/3/14.
 */
    function main(context) {
        var con = createconnection();
        for(var i=0;i<context.enableIds.length;i++){
            var enableId = context.enableIds[i];
            var result = multiexec(con,"update user set userStatus='停用' where userId=${userId}",{userId:enableId});
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