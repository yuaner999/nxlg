/**
 * Created by NEU on 2017/4/26.
 * 加载查询空教室信息
 */
function main(context) {
    var result = querypagedata(function () {/*
     SELECT *
     FROM
     `spareclassroom`
     WHERE week LIKE CONCAT('%',${searchStr},'%') OR classes LIKE CONCAT('%',${searchStr},'%') OR  classtype LIKE CONCAT('%',${searchStr},'%') OR weekday LIKE CONCAT('%',${searchStr},'%')
     order by cast(week as signed integer) asc,weekday asc, cast(classes as signed integer) asc
     */},context,"",context.pageNum,context.pageSize);
    return result;
}
