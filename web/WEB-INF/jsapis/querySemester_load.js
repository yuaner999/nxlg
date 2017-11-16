/**
 * Created by NEUNB_Lisy on 2017/6/5.
 */
function main(context){
    //加载所有学期
    var result=query(function () {/*
        SELECT *
        FROM `nxlg`.`arrangecourse`
        WHERE 1=1
        ORDER BY `arrangecourse`.`semester` DESC
    */},context,"");
    return result;
}