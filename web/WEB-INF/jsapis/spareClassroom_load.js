/**
 * Created by NEU on 2017/4/26.
 * 加载查询空教室信息
 */
function main(context) {
    var result = querypagedata(function () {/*
     SELECT *
     FROM
     `spareclassroom`
     WHERE
     case when ${teachweek} is not null and ${teachweek}<>""  then week =${teachweek}else 1=1 end
     and case when ${weekday} is not null and ${weekday}<>""  then weekday =${weekday} else 1=1 end
     and case when ${classes} is not null and ${classes}<>""  then classes =${classes} else 1=1 end
     order by cast(week as signed integer) asc,weekday asc, cast(classes as signed integer) asc
     */},context,"",context.pageNum,context.pageSize);
    return result;
}
