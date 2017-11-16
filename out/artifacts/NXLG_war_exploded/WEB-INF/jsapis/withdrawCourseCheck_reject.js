
/**
 * Created by NEU on 2017/5/23.
 */
function main(context){
    //数据非空判断
    if(context.studentId == null){
        return false;
    }
    context.SMS=uuid();
    
    var con=createconnection();
    var a=query(function(){/*
     SELECT * FROM `user` WHERE typeId=${studentId};
     */},context,"");
    if(a==null||a.length<1){
        return 0;   //该学生不是系统用户
    }else {
        context.id = a[0].userId;//发消息
        var rr = multiexec(con, function () {/*
         INSERT INTO message (
         `messageId`,
         `messageTitle`,
         `messageContent`,
         `messageDate`,
         `isRead`,
         `receiverId`,
         `isDelete`
         )
         VALUES
         (
         ${SMS},
         "退课拒绝通知",
         ${str},
         NOW(),
         "否",
         ${id},
         "否")
         */}, context);
        if (!rr) {
            rollback(con);
            closeconnection(con)
            return false;
        }
        var r = multiexec(con, function () {/*
         UPDATE  `nxlg`.`stuchoosecourse`  SET `scc_status` ="退课拒绝",`Rreason` =${str} WHERE `scc` = ${scc}
         */}, context);
        if (!r) {
            rollback(con);
            closeconnection(con);
            //如果添加数据失败，撤回发送的消息
            var b = exec(function () {/*
             DELETE
             FROM
             `nxlg`.`message`
             WHERE `messageId` = ${SMS};
             */}, context);
            return false;
        }
        commit(con);
        closeconnection(con);
        return true;
    }

}
