/**
 * Created by NEU on 2017/3/14.
 */
function main(context) {
    //加载角色
    var result = querypagedata(function () {/*
     SELECT
     `role`.*
     FROM `role`
     WHERE roleName LIKE CONCAT('%',${searchStr},'%') and isNeuNb='否'
     order by convert(roleName USING gbk) COLLATE gbk_chinese_ci asc
     */},context,"",context.pageNum,context.pageSize);
    return result;
}