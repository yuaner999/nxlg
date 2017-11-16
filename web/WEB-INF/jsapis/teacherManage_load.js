/**
 * Created by NEU on 2017/3/18.
 */
function main(context) {
    //加载教师信息
    var result = querypagedata(function () {/*
     SELECT *
     FROM `teacher`
     WHERE
     case when ${teacherNumber} is not null and ${teacherNumber}<>""  then teacherNumber LIKE CONCAT('%',${teacherNumber},'%') else 1=1 end
     and case when ${teacherName} is not null and ${teacherName}<>""  then teacherName LIKE CONCAT('%',${teacherName},'%') else 1=1 end
     and case when ${teachUnit} is not null and ${teachUnit}<>""  then teachUnit LIKE CONCAT('%',${teachUnit},'%') else 1=1 end
     order by teacherNumber
     */},context,"",context.pageNum,context.pageSize);
    return result;
}