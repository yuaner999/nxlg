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
     and case when ${majorName} is not null and ${majorName}<>""  then major.majorName LIKE CONCAT('%',${majorName},'%') else 1=1 end
     and case when ${majorCollege} is not null and ${majorCollege}<>""  then major.majorCollege=${majorCollege} else 1=1 end
     and case when ${subject} is not null and ${subject}<>""  then major.subject=${subject} else 1=1 end
     and case when ${checkType} is not null and ${checkType}<>""  then major.checkType=${checkType} else 1=1 end
     and case when ${majorStatus} is not null and ${majorStatus}<>""  then major.majorStatus=${majorStatus} else 1=1 end
     and case when ${checkStatus} is not null and ${checkStatus}<>""  then major.checkStatus=${checkStatus} else 1=1 end
     and checkStatus="已通过"
     order by convert(majorCollege USING gbk) COLLATE gbk_chinese_ci,convert(majorName USING gbk) COLLATE gbk_chinese_ci
     */},context,"",context.pageNum,context.pageSize);
    return result;
}