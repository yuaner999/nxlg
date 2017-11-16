/**
 * Created by NEU on 2017/4/19.
 */
function main(context){
    var result=querypagedata(function(){/*
     select * from `major`
     where (isDelete is null or isDelete="否") 
     and ( ${searchStr} IS NULL
     or majorCollege LIKE CONCAT('%',${searchStr},'%')
     or majorName LIKE CONCAT('%',${searchStr},'%')
     or subject LIKE CONCAT('%',${searchStr},'%')
     or checkType LIKE CONCAT('%',${searchStr},'%')
     or majorStatus LIKE CONCAT('%',${searchStr},'%')
     or checkStatus LIKE CONCAT('%',${searchStr},'%'))
     and checkStatus="已通过"
     order by convert(majorCollege USING gbk) COLLATE gbk_chinese_ci,convert(majorName USING gbk) COLLATE gbk_chinese_ci
     */},context,"",context.pageNum,context.pageSize);
    return result;
}