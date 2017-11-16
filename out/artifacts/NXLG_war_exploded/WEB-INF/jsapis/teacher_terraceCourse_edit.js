/**
 * Created by NEU on 2017/4/28.
 */
function main(context){
    //数据非空判断
    if(context.terraceId == null ||context.majorId == null||context.mtc_id == null){
        return false;
    }
    //修改
    var con = createconnection();
    var v=query(function(){/*
     SELECT * FROM `majorterracecourse` WHERE `majorId`=${majorId} and   `terraceId`=${terraceId} and mtc_grade=${ep_grade} and `courseId`=${courseId} and `mtc_courseTerm`=${mtc_courseTerm} and
     mtc_id<>${mtc_id} and mtc_id<>${mtc_relationId} and (mtc_isDelete IS NULL OR mtc_isDelete="否")
     */},context,"");
    if(v.length>0){
        rollback(con);
        closeconnection(con);
        return 0;
    }
    if(context.mtc_checkStatus=='已通过'){//已通过，修改时新建一条数据
        var rr=query(function(){/*
         select * from `majorterracecourse` where mtc_relationId=${mtc_id} AND mtc_checkStatus="待审核" AND (mtc_isDelete IS NULL OR mtc_isDelete="否")
         */},context,"");
        if(rr.length>0){
            rollback(con);
            closeconnection(con);
            return 1;
        }
        var result=multiexec(con,function(){/*
         insert into `majorterracecourse` (
         `mtc_id`,
         `majorId`,
         `terraceId`,
         `courseId`,
          mtc_grade,
         `mtc_courseTerm`,
         `mtc_majorWay`,
         `mtc_note`,
         `mtc_relationId`,
         `mtc_checkStatus`,
         `mtc_checkType`,
         `mtc_setman`,
         `mtc_settime`
         )
         values
         (UUID(),
         ${majorId},
         ${terraceId},
         ${courseId},
         ${mtc_grade},
         ${mtc_courseTerm},
         ${mtc_majorWay},
         ${mtc_note},
         ${mtc_id},
         "待审核",
         "修改",
         ${sessionUserName},
         NOW())
         */},context);
        if(!result){
            rollback(con);
            closeconnection(con);
            return 3;
        }
    }else{
        var result =multiexec(con,function () {/*
         UPDATE
         `majorterracecourse`
         SET
         `mtc_courseTerm` =  ${mtc_courseTerm},
         `mtc_majorWay` =  ${mtc_majorWay},
         `mtc_note` =  ${mtc_note},
         `mtc_checkStatus` ="待审核",
         `mtc_refuseReason`=NULL,
         `mtc_setman` = ${sessionUserName},
         `mtc_settime` = NOW()
         WHERE `mtc_id` = ${mtc_id}
         */},context);
        if(!result){
            rollback(con);
            closeconnection(con);
            return 3;
        }
    }
    commit(con);
    closeconnection(con);
    return 2;
}
var inputsamples=[{
    mtc_id:"2"
}]