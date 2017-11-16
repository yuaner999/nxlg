/**
 * Created by gq on 2017/6/3.
 */
function main(context){
    var rr= querypagedata(function () {/*
     SELECT * from withdrawcourse_info
     WHERE (`studentName` LIKE CONCAT('%',${searchStr},'%') or `studentNum` LIKE CONCAT('%',${searchStr},'%') or `term` LIKE CONCAT('%',${searchStr},'%'))
     and case when ${course} is not null and ${course} <> '' then courseId=${course} else 1=1 end
     and case when ${major} is not null and ${major} <> '' then majorId=${major} else 1=1 end
     and `iscomfirm` = "1" and `scc_status` = "退课通过"
     */},context,"",context.pageNum,context.pageSize);
    return rr;
}
var inputsamples=[{
    pageNum:'1',
    pageSize:'10',
    searchStr:'',
    course:'1597f967-5bd6-4ca8-8fd7-95ad688970f3',
    semester:'2016/2017第二学期',
    major:'03271540-5aaa-42d3-80d0-11b4b716b3c6'
}]