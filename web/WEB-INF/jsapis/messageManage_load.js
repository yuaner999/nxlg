/**
 * Created by NEU on 2017/5/16.
 * 获取消息
 */
function main(context){
    var r=querypagedata(function () {/*
    SELECT  *,FROM_UNIXTIME(UNIX_TIMESTAMP(messageDate),'%Y-%m-%d %H:%i:%s') as messageDate
    FROM `message`
    WHERE `receiverId` = ${sessionUserID} AND `isDelete` ='否'
    AND messageTitle LIKE CONCAT('%',${searchStr},'%')
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="1" then isRead="是" else 1=1 end
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="0" then isRead="否" else 1=1 end
    ORDER BY isRead,`messageDate` DESC
    */},context,"",context.pageNum,context.pageSize);
    return r;
}
