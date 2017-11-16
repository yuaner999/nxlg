/**
 * Created by NEU on 2017/3/16.
 */
function main(context) {
    //加载学生信息
    var result = querypagedata(function () {/*
     SELECT *
     FROM
     `student`
     WHERE
     case when ${studentName} is not null and ${studentName}<>""  then studentName LIKE CONCAT('%',${studentName},'%') else 1=1 end
     and case when ${studentNum} is not null and ${studentNum}<>""  then studentNum LIKE CONCAT('%',${studentNum},'%') else 1=1 end
     and case when ${studentCollege} is not null and ${studentCollege}<>""  then studentCollege=${studentCollege} else 1=1 end
     and case when ${studentMajor} is not null and ${studentMajor}<>""  then studentMajor=${studentMajor} else 1=1 end
     and case when ${studentClass} is not null and ${studentClass}<>""  then studentClass=${studentClass} else 1=1 end
     and case when ${studentGrade} is not null and ${studentGrade}<>""  then studentGrade=${studentGrade} else 1=1 end
     order by convert(studentCollege USING gbk) COLLATE gbk_chinese_ci asc,
     convert(studentMajor USING gbk) COLLATE gbk_chinese_ci asc,studentGrade,
     convert(studentClass USING gbk) COLLATE gbk_chinese_ci asc,studentNum
     */},context,"",context.pageNum,context.pageSize);
    return result;
}