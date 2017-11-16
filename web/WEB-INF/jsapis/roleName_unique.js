/**
 * Created by NEU on 2017/3/21.
 */
function main(context) {
    //用户唯一
    var result = query(function () {/*
     SELECT * FROM  role
     WHERE
     `roleName` = ${roleName}
     */},context,"");
    return result;
}