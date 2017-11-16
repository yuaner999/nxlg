/**
 * Created by NEU on 2017/4/19.
 */
/**
 * Created by NEU on 2017/4/19.
 */
function main(contexts) {
    //基础数据非空判断
    if(contexts.passIds.length<=0){
        return false;
    }
    var con = createconnection();
    //遍历所有的数据
    for (var i = 0; i < contexts.passIds.length; i++) {
        var courseId = contexts.passIds[i].courseId;//课程ID
        var result = multiexec(con, function () {/*
         update course set checkStatus='已通过',refuseReason='' where courseId=${courseId};
         */}, {courseId: courseId});//设置状态为已通过
        if (!result) {//出错回滚
            rollback(con);
            closeconnection(con);
            return false;
        }
        if(contexts.passIds[i].relationId!=""&&contexts.passIds[i].relationId!=null){
            if (contexts.passIds[i].checkType == "删除") {//如果是删除
                result = multiexec(con, function () {/*
                 update course set checkStatus='已删除' where courseId=${relationId};
                 delete from course where courseId=${courseId};
                 */}, {relationId: contexts.passIds[i].relationId, courseId: courseId});//删除处理，删除临时记录，更新原纪录isDelete为是
            } else if (contexts.passIds[i].checkType == "修改") {//如果是修改
                result = multiexec(con, function () {/*
                 delete from course where courseId=${relationId};
                 update course set courseId=${relationId},relationId='' where courseId=${courseId};
                 */}, {relationId: contexts.passIds[i].relationId, courseId: courseId});//将修改记录更新，删除临时记录
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
