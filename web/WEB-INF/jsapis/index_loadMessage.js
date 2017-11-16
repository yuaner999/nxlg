/**
 * Created by NEU on 2017/3/14.
 */
function main(context) {
    //获取用户的所有消息
    var result = query(function () {/*
        select *,month(messageDate) month,day(messageDate) day,hour(messageDate) hour,minute(messageDate) minute
            from message where receiverId=${sessionUserID} and isRead='否' and isDelete='否' order by  messageDate desc
    */},context,"")
    for(var i=0;i<result.length;i++){
        if(result[i].hour<10){
            result[i].hour="0"+result[i].hour;
        }
        if(result[i].minute<10){
            result[i].minute="0"+result[i].minute;
        }  
    }
    return result;
}
var inputsamples=[{
    sessionUserID:"c4bc94ee-1f47-11e7-9c14-00ac9c2c0afa"
}]