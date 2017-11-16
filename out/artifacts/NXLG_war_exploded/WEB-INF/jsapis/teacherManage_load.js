/**
 * Created by NEU on 2017/3/18.
 */
function main(context) {
    //加载教师信息
    var result = querypagedata(function () {/*
     SELECT *
     FROM `teacher`
     WHERE teacherNumber LIKE CONCAT('%',${searchStr},'%') OR teacherName LIKE CONCAT('%',${searchStr},'%') OR teachUnit LIKE CONCAT('%',${searchStr},'%') 
     order by teacherNumber
     */},context,"",context.pageNum,context.pageSize);
    return result;
}