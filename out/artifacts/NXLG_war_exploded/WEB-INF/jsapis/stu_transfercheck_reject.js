/**
 * Created by NEU on 2017/6/12.
 */
function main(context) {
    //基础数据非空判断
    if(context.transferid == null){
        return false;
    }
    //调剂申请驳回
    var result = exec(function () {/*
     UPDATE
     `transferapply`
     SET
     `status` = "已驳回",
     `reject` = ${reason}
     WHERE transferid=${transferid};
     */},context);
    return result;
}