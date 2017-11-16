/**
 * Created by gq on 2017/5/27.
 * 加载所有学院
 */
function main(context) {
    var result = querypagedata(function () {/*
     SELECT *,FROM_UNIXTIME(UNIX_TIMESTAMP(createDate),'%Y-%m-%d %H:%i:%s') AS createDate,
                FROM_UNIXTIME(UNIX_TIMESTAMP(updateDate),'%Y-%m-%d %H:%i:%s') AS updateDate
     FROM wordbook WHERE wordbookKey='学院'
     and case when (${searchStr} is not null and ${searchStr}<>"") then wordbookValue like concat ('%',${searchStr},'%') else 1=1 end
     */},context,"",context.pageNum,context.pageSize);
    return result;
}