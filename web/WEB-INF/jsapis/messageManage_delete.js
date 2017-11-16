/**
 * Created by NEU on 2017/5/16.
 * 删除消息
 */
function main(context) {
    for(var i=0;i<context.deleteIds.length;i++){
        context.messageId= context.deleteIds[i];
        var r=exec(function () {/*
         UPDATE
         `message`
         SET
         `isDelete` = '是'
         WHERE `messageId` = ${messageId}
         */},context);
        if(!r){
            return false;
        }
    }
    return true;
}
