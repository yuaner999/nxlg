/**
 * Created by NEUNB_Lisy on 2017/5/24.
 */
function main(context){
    var result=querypagedata(function(){/*
     SELECT *
     FROM
     `classroomtype`
     WHERE crt_type LIKE CONCAT('%',${searchStr},'%')
     OR crt_usage LIKE CONCAT('%',${searchStr},'%')
     order by crt_usage
     */},context,"",context.pageNum,context.pageSize);
    return result;
}