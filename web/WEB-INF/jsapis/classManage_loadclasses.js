/**
 * Created by gq on 2017/6/1.
 */
function main(context) {
    var result = querypagedata(function () {/*
     SELECT *,FROM_UNIXTIME(UNIX_TIMESTAMP(createDate),'%Y-%m-%d') AS createDate,
     FROM_UNIXTIME(UNIX_TIMESTAMP(updateDate),'%Y-%m-%d') AS updateDate
     FROM class WHERE 1=1
      and case when (${searchStr} is not null and ${searchStr}<>"") then className like concat ('%',${searchStr},'%') else 1=1 end
     */},context,"",context.pageNum,context.pageSize);
    return result;
}