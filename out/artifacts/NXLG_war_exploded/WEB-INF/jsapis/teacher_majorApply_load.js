/**
 * Created by NEU on 2017/3/17.
 */
function main(context){
    var result=querypagedata(function(){/*
     select * from `major`
     where (isDelete is null or isDelete="否") and (majorCollege LIKE CONCAT('%',${searchStr},'%')
     or majorName LIKE CONCAT('%',${searchStr},'%')
     or subject LIKE CONCAT('%',${searchStr},'%')
     or checkType LIKE CONCAT('%',${searchStr},'%')
     or majorStatus LIKE CONCAT('%',${searchStr},'%')
     or checkStatus LIKE CONCAT('%',${searchStr},'%'))
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="1" then checkStatus="已通过" else 1=1 end
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="0" then (checkStatus="待审核" or checkStatus="未通过") else 1=1 end
     order by convert(majorCollege USING gbk) COLLATE gbk_chinese_ci,convert(majorName USING gbk) COLLATE gbk_chinese_ci
     */},context,"",context.pageNum,context.pageSize);
    return result;
}