/**
 * Created by NEU on 2017/6/1.
 */
function main(context) {
    var result = query(function () {/*
     SELECT *
     FROM
     `major`
     WHERE checkStatus="已通过" and majorStatus="启用"  and (isDelete is null or isDelete<>"是")
     */},context,"");
    return result;
}
