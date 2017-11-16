/**
 * Created by NEU on 2017/3/16.
 */
function main(context){
    var result=querypagedata(function(){/*
     SELECT *
     FROM
     `classroom`
     WHERE
     case when ${classroomName} is not null and ${classroomName}<>""  then classroomName LIKE CONCAT('%',${classroomName},'%') else 1=1 end
     and case when ${classroomType} is not null and ${classroomType}<>""  then classroomType=${classroomType} else 1=1 end
     and case when ${campus} is not null and ${campus}<>""  then campus=${campus} else 1=1 end
     and case when ${building} is not null and ${building}<>""  then building=${building} else 1=1 end
     order by campus,classroomType
    */},context,"",context.pageNum,context.pageSize);
    return result;
}
