/**
 * Created by NEU on 2017/3/17.
 */
function main(context) {
    //修改时获取用户ID
    var result = query(function () {/*
     SELECT userId FROM user
     WHERE typeId = ${adminId}
     */},context,"");
    return result;
}