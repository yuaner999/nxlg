/**
 * Created by NEU on 2017/3/15.majorId:context.majorId
 */
function main(contexts) {
    //基础数据非空判断
    if(contexts.passIds.length < 1){
        return false;
    }
    var realName;

    var rr = query(function () {/*
     SELECT * FROM
     `nxlg`.`user`
     LEFT JOIN `nxlg`.`teacher`
     ON (`user`.`typeId` = `teacher`.`teacherId`)
     LEFT JOIN `nxlg`.`admin`
     ON (`user`.`typeId` = `admin`.`adminId`)
     WHERE userId=${sessionUserID}
     */},contexts,"");
    if(rr){
        var type = rr[0].typeName;
        if(type=="管理员"){
            realName = rr[0].adminName;
        }else if(type=="教师"){
            realName =rr[0].teacherName};
    }else{
        return false;
    }
    var con = createconnection();
    //遍历所有的数据
    for (var i = 0; i < contexts.passIds.length; i++) {
        var majorId = contexts.passIds[i].majorId;//专业ID
        var result = multiexec(con, function () {/*
         update major set checkStatus='已通过', `checkMan` = ${realName},
         `checkDate` = now()   where majorId=${majorId};
         */}, {majorId: majorId,realName:realName});//设置状态为已通过
        if (!result) {//出错回滚
            rollback(con);
            closeconnection(con)
            return false;
        }
        if (contexts.passIds[i].checkType == "删除") {//如果是删除
            result = multiexec(con, function () {/*
             update major set isDelete='是' where majorId=${relationId};
             delete from major where majorId=${majorId};
             */}, {relationId: contexts.passIds[i].relationId, majorId: majorId});//删除处理，删除临时记录，更新原纪录isDelete为是
        } else if (contexts.passIds[i].checkType == "修改") {//如果是修改
            result = multiexec(con, function () {/*
             delete from major where majorId=${relationId};
             update major set majorId=${relationId},relationId='',`checkMan` = ${realName},
             `checkDate` = now() where majorId=${majorId};
             update majorrecord set result = '已通过' where majorId=${relationId};
             */}, {relationId: contexts.passIds[i].relationId, majorId: majorId,realName:realName});//将修改记录更新，删除临时记录
        } else if (contexts.passIds[i].checkType == "启用") {//如果是启用
            result = multiexec(con, function () {/*
             delete from major where majorId=${relationId};
             update major set majorId=${relationId},relationId='',`checkMan` = ${realName},
             `checkDate` = now() where majorId=${majorId};
             update majorrecord set result = '已通过' where majorId=${relationId};
             */}, {relationId: contexts.passIds[i].relationId, majorId: majorId,realName:realName});//将启用记录更新，删除临时记录
        } else if (contexts.passIds[i].checkType == "停用") {//如果是停用
            result = multiexec(con, function () {/*
             delete from major where majorId=${relationId};
             update major set majorId=${relationId},relationId='',`checkMan` = ${realName},
             `checkDate` = now() where majorId=${majorId};
             update majorrecord set result = '已通过' where majorId=${relationId};
             */}, {relationId: contexts.passIds[i].relationId, majorId: majorId,realName:realName});//将停用记录更新，删除临时记录
        }
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

