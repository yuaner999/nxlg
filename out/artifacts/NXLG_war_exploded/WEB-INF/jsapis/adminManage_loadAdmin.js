/**
 * Created by NEU on 2017/3/17.
 */
function main(context) {
    //加载用户
    var result = querypagedata(function () {/*
     SELECT * FROM admin
     WHERE
     adminName LIKE concat('%',${searchStr},'%') OR adminPhone LIKE concat('%',${searchStr},'%') OR adminEmail LIKE concat('%',${searchStr},'%')
     order by convert(adminName USING gbk) COLLATE gbk_chinese_ci asc
     */},context,"",context.pageNum,context.pageSize);
    return result;
}