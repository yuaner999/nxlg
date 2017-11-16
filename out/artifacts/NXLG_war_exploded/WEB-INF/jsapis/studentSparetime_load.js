/**
 * Created by NEU on 2017/5/10.
 */
function main(context) {
    //加载专业信息
    var result = querypagedata(function () {/*
     SELECT
     `majorId`,
     `majorCollege`,
     `majorCode`,
     `majorName`,
     `scheduleTime`
     FROM `major`
     WHERE checkStatus='已通过' AND (majorCollege LIKE CONCAT('%',${searchStr},'%') OR majorCode LIKE CONCAT('%',${searchStr},'%') OR majorName LIKE CONCAT('%',${searchStr},'%'))
     order by majorCode
     */},context,"",context.pageNum,context.pageSize);
    return result;
}