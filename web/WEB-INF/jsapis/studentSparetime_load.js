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
     WHERE checkStatus='已通过'
     and case when ${majorCode} is not null and ${majorCode}<>""  then majorCode LIKE CONCAT('%',${majorCode},'%') else 1=1 end
     and case when ${majorName} is not null and ${majorName}<>""  then majorName LIKE CONCAT('%',${majorName},'%') else 1=1 end
     and case when ${majorCollege} is not null and ${majorCollege}<>""  then majorCollege =${majorCollege} else 1=1 end
     order by majorCode
     */},context,"",context.pageNum,context.pageSize);
    return result;
}