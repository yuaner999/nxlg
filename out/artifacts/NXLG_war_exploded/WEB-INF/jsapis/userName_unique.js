/**
 * Created by NEU on 2017/3/16.
 */
function main(context) {
    //用户唯一
    var result = query(function () {/*
     SELECT * FROM  user
     WHERE
     `userName` = ${userName}
     */},context,"");
    return result;
}