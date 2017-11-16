/**
 * Created by NEU on 2017/3/18.
 */
function main(context) {
    //基础数据非空判断
    if(context.majorId == null){
        return false;
    }
    //判断驳回理由是否为空
    if(context.reason.trim() == ""){
        return false;
    }
    if(context.relationId == ""){
        return false;
    }
    //修改数据字典
    var result = exec(function () {/*
     UPDATE
     `major`
     SET
     `checkStatus` = "未通过",
     `refuseReason` = ${reason}
     WHERE `majorId` = ${majorId};
     update majorrecord set result = '未通过' where majorId = ${relationId};
     */},context);
    return result;
}