/**
 * Created by zcy on 2017/5/26.
 * 加载课程教材信息
 */
function main(context) {
    var result=querypagedata(function () {/*
     SELECT c.`chineseName`,c.`courseCode`,t.`name`,t1.`name` AS name1,c.`issparecourse`,c.`courseId`
     FROM course AS c
     LEFT JOIN teachingmaterials AS t ON(t.`tmId`=c.`coursebookid`)
     LEFT JOIN teachingmaterials AS t1 ON(t1.`tmId`=c.`sparecoursebookid`)
     WHERE c.`checkStatus`='已通过' AND c.`courseStatus`='启用' AND (c.`courseCode` LIKE CONCAT('%',${searchStr},'%'))
     ORDER BY c.`courseCode`

    */},context,"",context.pageNum,context.pageSize);
    return result;
}

var inputsamples=[
    {
        searchStr:""
    }
]