function main(context){
    var result=querypagedata(function(){/*
     SELECT majorrecord.type,majorrecord.result,majorrecord.before,majorrecord.after,
     FROM_UNIXTIME(UNIX_TIMESTAMP(majorrecord.time),'%Y-%m-%d %H:%i:%s') AS mytime,major.`majorName` FROM majorrecord
     LEFT JOIN major ON major.`majorId` = majorrecord.`majorId`
     where
     case when ${majorName} is not null and ${majorName}<>""  then majorName LIKE CONCAT('%',${majorName},'%') else 1=1 end
     and case when ${checkType} is not null and ${checkType}<>""  then type=${checkType} else 1=1 end
     and case when ${checkStatus} is not null and ${checkStatus}<>""  then result=${checkStatus} else 1=1 end
     ORDER BY TIME DESC
     */},context,"",context.pageNum,context.pageSize);
    return result;
}