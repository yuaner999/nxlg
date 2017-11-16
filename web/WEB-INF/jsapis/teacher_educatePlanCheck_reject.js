/**
 * Created by NEU on 2017/5/2.
 */
function main(context) {
    //基础数据非空判断
    if(context.ep_id == null){
        return false;
    }
    //判断驳回理由是否为空
    if(context.reason.trim() == ""){
        return false;
    }

    //修改数据字典
    var result = exec(function () {/*
     UPDATE
     `educateplane`
     SET
     `ep_checkStatus` = "未通过",
     `ep_refuseReason` = ${reason}
     WHERE `ep_id` = ${ep_id}
     */},context);
    return result;
}