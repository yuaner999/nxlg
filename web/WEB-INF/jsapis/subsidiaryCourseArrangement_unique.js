/**
 * Created by NEUNB_Lisy on 2017/5/16.
 */
function main(context) {
    //用来判断添加和修改时课程代码是否已存在
    var result = query(function () {/*
     SELECT * FROM  arrangelesson
     WHERE
     `al_Id` = ${al_Id}
     */},context,"");
    return result;
}