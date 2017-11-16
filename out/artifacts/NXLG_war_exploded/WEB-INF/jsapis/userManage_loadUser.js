/**
 * Created by NEU on 2017/3/14.
 */
function main(context) {
    //加载用户
    var result = querypagedata(function () {/*
        SELECT userId,userName,typeName,userStatus,A.roleId,B.roleName FROM user A left join role B on A.roleId=B.roleId
        WHERE
        A.isNeuNb = '否' AND (userName LIKE concat('%',${searchStr},'%') OR typeName LIKE concat('%',${searchStr},'%') OR userStatus LIKE concat('%',${searchStr},'%'))
        order by convert(userName USING gbk) COLLATE gbk_chinese_ci asc
     */},context,"",context.pageNum,context.pageSize);
 return result;
}