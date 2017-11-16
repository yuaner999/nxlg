/**
 * Created by NEUNB_Lisy on 2017/5/24.
 */
function main(context){
    var result=querypagedata(function(){/*
     SELECT *
     FROM
     `classroomtype`
     WHERE
     case when ${crt_type} is not null and ${crt_type}<>""  then crt_type LIKE CONCAT('%',${crt_type},'%') else 1=1 end
     and case when ${crt_usage} is not null and ${crt_usage}<>""  then crt_usage LIKE CONCAT('%',${crt_usage},'%') else 1=1 end
     order by crt_usage
     */},context,"",context.pageNum,context.pageSize);
    return result;
}