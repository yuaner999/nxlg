function main(context){
    var result=querypagedata(function(){/*
     SELECT majorrecord.type,majorrecord.result,majorrecord.before,majorrecord.after,
     FROM_UNIXTIME(UNIX_TIMESTAMP(majorrecord.time),'%Y-%m-%d %H:%i:%s') AS mytime,major.`majorName` FROM majorrecord
     LEFT JOIN major ON major.`majorId` = majorrecord.`majorId`
     where ${searchStr} IS NULL
     or majorName LIKE CONCAT('%',${searchStr},'%')
     or type LIKE CONCAT('%',${searchStr},'%')
     or result LIKE CONCAT('%',${searchStr},'%')
     ORDER BY TIME DESC

     */},context,"",context.pageNum,context.pageSize);
    return result;
}