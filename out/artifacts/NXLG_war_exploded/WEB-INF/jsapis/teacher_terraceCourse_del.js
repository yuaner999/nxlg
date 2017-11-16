/**
 * Created by NEU on 2017/5/3.
 */
function main(context){
    //删除
    var con = createconnection();
    if(context.mtc_checkStatus=='已通过'){
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
         "删除",
         ${sessionUserName},
         NOW())
         */},context);
        if(!result){
            rollback(con);
            closeconnection(con);
            return 3;
        }
    }else{
        var result = multiexec(con,"delete from majorterracecourse where mtc_id=${mtc_id}",context);
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