/**
 * Created by NEU on 2017/5/16.
 */
function main(contexts) {
    //基础数据非空判断
    if(contexts.passIds.length<=0){
        return false;
    }
    var con = createconnection();
    //遍历所有的数据
    for (var i = 0; i < contexts.passIds.length; i++) {
        var tc_id = contexts.passIds[i].tc_id;
        var result = multiexec(con, function () {/*
         update teachtask set tc_checkStatus='已通过',tc_refuseReason='' where tc_id=${tc_id};
         */}, {tc_id: tc_id});//设置状态为已通过
        if (!result) {//出错回滚
            rollback(con);
            closeconnection(con)
            return false;
        }
        if(contexts.passIds[i].tc_relationId!=null&&contexts.passIds[i].tc_relationId!=""){
            if (contexts.passIds[i].tc_checkType == "删除") {//如果是删除
                result = multiexec(con, function () {/*
                 update teachtask set tc_isDelete='是' where tc_id=${tc_relationId};
                 delete from teachtask where tc_id=${tc_id};
                 delete from tcmajor where tcm_tc_id =${tc_id};
                 */}, {tc_relationId: contexts.passIds[i].tc_relationId, tc_id: tc_id});//删除处理，删除临时记录，更新原纪录isDelete为是
            } else if (contexts.passIds[i].tc_checkType == "修改") {//如果是修改
                result = multiexec(con, function () {/*
                 delete from teachtask where tc_id=${tc_relationId};
                 update teachtask set tc_id=${tc_relationId},tc_relationId='' where tc_id=${tc_id};
                 delete from tcmajor where tcm_tc_id=${tc_relationId};
                 update tcmajor set tcm_tc_id=${tc_relationId} where tcm_tc_id=${tc_id};
                 */}, {tc_relationId: contexts.passIds[i].tc_relationId, tc_id: tc_id});//将修改记录更新，删除临时记录
            }
            if (!result) {//出错回滚
                rollback(con);
                closeconnection(con)
                return false;
            }
        }
    }
    commit(con);//提交
    closeconnection(con);//关闭连接
    return true;
}
