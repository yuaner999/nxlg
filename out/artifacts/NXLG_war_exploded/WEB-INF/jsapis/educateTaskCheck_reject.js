/**
 * Created by NEU on 2017/5/16.
 */
function main(context) {
    //基础数据非空判断
    if(contexts.tc_id == null){
        return false;
    }
    var result = exec(function () {/*
     UPDATE
     `teachtask`
     SET
     `tc_checkStatus` = "未通过",
     `tc_refuseReason` = ${reason}
     WHERE `tc_id` = ${tc_id};
     delete from tcmajor where tcm_tc_id=${tc_id};
     */},context);
    return result;
}
