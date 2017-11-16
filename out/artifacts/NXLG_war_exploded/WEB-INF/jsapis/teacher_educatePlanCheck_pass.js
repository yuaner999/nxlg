/**
 * Created by NEU on 2017/5/2.majorId:context.majorId
 */
function main(contexts) {
    //基础数据非空判断
    if(contexts.passIds.length<1){
        return false;
    }
    var con = createconnection();
    //遍历所有的数据
    for (var i = 0; i < contexts.passIds.length; i++) {
        var ep_id = contexts.passIds[i].ep_id;
        var result = multiexec(con, function () {/*
         update educateplane set ep_checkStatus='已通过' where ep_id=${ep_id};
         */}, {ep_id: ep_id});//设置状态为已通过
        if (!result) {//出错回滚
            rollback(con);
            closeconnection(con)
            return false;
        }
        if (contexts.passIds[i].ep_checkType == "删除") {//如果是删除
            result = multiexec(con, function () {/*
             update educateplane set ep_isDelete='是' where ep_id=${ep_relationId};
             delete from educateplane where ep_id=${ep_id};
             */}, {ep_relationId: contexts.passIds[i].ep_relationId,ep_id: ep_id});//删除处理，删除临时记录，更新原纪录isDelete为是
        } else if (contexts.passIds[i].ep_checkType == "修改") {//如果是修改
            result = multiexec(con, function () {/*
             delete from educateplane where ep_id=${ep_relationId};
             update educateplane set ep_id=${ep_relationId},ep_relationId='' where ep_id=${ep_id};
             */}, {ep_relationId: contexts.passIds[i].ep_relationId,ep_id: ep_id});//将修改记录更新，删除临时记录
        }
        // else if (contexts.passIds[i].checkType == "启用") {//如果是启用
        //     result = multiexec(con, function () {/*
        //      delete from major where majorId=${relationId};
        //      update major set majorId=${relationId},relationId='' where majorId=${majorId};
        //      */}, {mtc_relationId: contexts.passIds[i].mtc_relationId,mtc_id: mtc_id});//将启用记录更新，删除临时记录
        // } else if (contexts.passIds[i].checkType == "停用") {//如果是停用
        //     result = multiexec(con, function () {/*
        //      delete from major where majorId=${relationId};
        //      update major set majorId=${relationId},relationId='' where majorId=${majorId};
        //      */}, {mtc_relationId: contexts.passIds[i].mtc_relationId,mtc_id: mtc_id});//将停用记录更新，删除临时记录
        // }
        if (!result) {//出错回滚
            rollback(con);
            closeconnection(con)
            return false;
        }
    }
    commit(con);//提交
    closeconnection(con);//关闭连接
    return true;
}

