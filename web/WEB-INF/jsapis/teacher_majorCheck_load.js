/**
 * Created by NEU on 2017/3/17.
 */
function main(context){
    var result=querypagedata(function(){/*
     select * from `major`
     where (isDelete is null or isDelete="否")
     and case when ${majorName} is not null and ${majorName}<>""  then major.majorName LIKE CONCAT('%',${majorName},'%') else 1=1 end
     and case when ${majorCollege} is not null and ${majorCollege}<>""  then major.majorCollege=${majorCollege} else 1=1 end
     and case when ${subject} is not null and ${subject}<>""  then major.subject=${subject} else 1=1 end
     and case when ${checkType} is not null and ${checkType}<>""  then major.checkType=${checkType} else 1=1 end
     and case when ${majorStatus} is not null and ${majorStatus}<>""  then major.majorStatus=${majorStatus} else 1=1 end
     and case when ${checkStatus} is not null and ${checkStatus}<>""  then major.checkStatus=${checkStatus} else 1=1 end
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="1" then checkStatus="待审核" else 1=1 end
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="2" then checkStatus="未通过" else 1=1 end
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="0" then (checkStatus="已通过" ) else 1=1 end
     order by convert(checkStatus USING gbk) COLLATE gbk_chinese_ci desc,convert(majorCollege USING gbk) COLLATE gbk_chinese_ci,convert(majorName USING gbk) COLLATE gbk_chinese_ci
     */},context,"",context.pageNum,context.pageSize);
    return result;
}