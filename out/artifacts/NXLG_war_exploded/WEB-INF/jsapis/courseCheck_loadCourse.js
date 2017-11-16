/**
 * Created by NEU on 2017/4/18.
 */
// 加载课程信息
function main(context) {
    var result = querypagedata(function () {/*
     SELECT
     `course`.*
     , `teacher`.*
     , `teachingmaterials`.*
     FROM
     `nxlg`.`course`
     LEFT JOIN `nxlg`.`teacher` 
     ON (`course`.`mainteacherid` = `teacher`.`teacherId`)
     LEFT JOIN `nxlg`.`teachingmaterials` 
     ON (`course`.`coursebookid` = `teachingmaterials`.`tmId`)
     WHERE (courseCode LIKE CONCAT('%',${searchStr},'%') OR chineseName LIKE CONCAT('%',${searchStr},'%'))
     and case when (${filter} is not null and ${filter}<>"" and ${filter}="1") then (checkStatus="已通过") else 1=1 end
     and case when (${filter} is not null and ${filter}<>"" and ${filter}="2") then (checkStatus="未通过" OR checkStatus="待写教材") else 1=1 end
     and case when (${filter} is not null and ${filter}<>"" and ${filter}="0") then (checkStatus="待审核") else 1=1 end
     order by convert(chineseName USING gbk) COLLATE gbk_chinese_ci asc,convert(checkStatus USING gbk) COLLATE gbk_chinese_ci desc
     */},context,"",context.pageNum,context.pageSize);
    return result;
}
var inputsamples=[
    {
        searchStr:"",
        filter:"1"
    }
]