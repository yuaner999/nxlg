/**
 * Created by NEU on 2017/4/18.
 */
function main(context){
    var result=querypagedata(function(){/*
     SELECT  `terraceId`,`terraceName`,`minCredits`,`minClasses`,`maxCredits`, `maxClasses`,
     FROM_UNIXTIME(UNIX_TIMESTAMP(startTime),'%Y-%m-%d %H:%i:%s') as startTime,
     FROM_UNIXTIME(UNIX_TIMESTAMP(endTime),'%Y-%m-%d %H:%i:%s')as endTime
     FROM `terrace` where terraceName LIKE CONCAT('%',${searchStr},'%') order by convert(terraceName USING gbk)
     */},context,"",context.pageNum,context.pageSize);
    return result;
}