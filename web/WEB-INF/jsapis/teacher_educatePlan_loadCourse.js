/**
 * Created by NEU on 2017/5/31.
 */
// 加载课程信息
function main(context) {
    var result = querypagedata(function () {/*
     SELECT *
     FROM
     `course`
     WHERE checkStatus="已通过" and courseStatus="启用" and (courseCode LIKE CONCAT('%',${searchStr},'%') OR chineseName LIKE CONCAT('%',${searchStr},'%'))
     order by courseCode,convert(chineseName USING gbk) COLLATE gbk_chinese_ci asc
     */},context,"",context.pageNum,context.pageSize);
    return result;
}