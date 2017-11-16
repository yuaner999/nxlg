/**
 * Created by NEU on 2017/5/16.
 * 设置全部消息已读
 */
function main(context) {
    //sessionUserName非空判断
    if(getsession(context,"sessionUserID") == null){
        return false;
    }
    var r=exec(function () {/*
     UPDATE
     `message`
     SET
     `isRead` = '是'
     WHERE `receiverId` = ${sessionUserID}
     */},context);
    return r;
}