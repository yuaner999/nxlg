/**
 * Created by NEU on 2017/3/16.
 */
function main(context) {
    //加载学生信息
    var result = querypagedata(function () {/*
     SELECT *
     FROM
     `student`
     WHERE studentName LIKE CONCAT('%',${searchStr},'%')
     OR studentNum LIKE CONCAT('%',${searchStr},'%')
     OR studentCollege LIKE CONCAT('%',${searchStr},'%')
     OR studentMajor LIKE CONCAT('%',${searchStr},'%')
     OR studentClass LIKE CONCAT('%',${searchStr},'%')
     OR studentGrade LIKE CONCAT('%',${searchStr},'%')
     order by convert(studentCollege USING gbk) COLLATE gbk_chinese_ci asc,
     convert(studentMajor USING gbk) COLLATE gbk_chinese_ci asc,studentGrade,
     convert(studentClass USING gbk) COLLATE gbk_chinese_ci asc,studentNum
     */},context,"",context.pageNum,context.pageSize);
    return result;
}