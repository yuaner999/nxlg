/**
 * Created by NEU on 2017/3/16.
 */
function main(context){
    var result=querypagedata(function(){/*
     SELECT *
     FROM
     `classroom`
     WHERE
     (classroomName LIKE CONCAT('%',${searchStr},'%')
     OR classroomType LIKE CONCAT('%',${searchStr},'%')
     OR campus LIKE CONCAT('%',${searchStr},'%')  
     OR building LIKE CONCAT('%',${searchStr},'%')) 
     order by campus,classroomType
    */},context,"",context.pageNum,context.pageSize);
    return result;
}
