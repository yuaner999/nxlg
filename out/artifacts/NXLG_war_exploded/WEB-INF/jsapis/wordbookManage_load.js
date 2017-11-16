/**
 * Created by NEU on 2017/3/15.
 */
function main(context){
    var result=querypagedata(function(){/*
     SELECT * FROM `wordbook` where wordbookKey LIKE CONCAT('%',${searchStr},'%') OR
        wordbookValue LIKE CONCAT('%',${searchStr},'%') order by convert(wordbookKey USING gbk) COLLATE gbk_chinese_ci,createDate desc
    */},context,"",context.pageNum,context.pageSize);
    return result;
}