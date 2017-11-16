/**
 * Created by NEU on 2017/5/2.
 */
function main(context) {
    //数据非空判断
    if(context.mtc_id == null){
        return false;
    }
    //判断驳回理由是否为空
    if(context.reason.trim() == ""){
        return false;
    }
    //修改数据字典
    var result = exec(function () {/*
     UPDATE
     `majorterracecourse`
     SET
     `mtc_checkStatus` = "未通过",
     `mtc_refuseReason` = ${reason}
     WHERE `mtc_id` = ${mtc_id}
     */},context);
    return result;
}