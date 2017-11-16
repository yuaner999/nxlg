/**
 * Created by NEU on 2017/5/3.
 */
function main(context){
    //删除
    var con = createconnection();
    if(context.ep_checkStatus=='已通过'){
        var rr=query(function(){/*
         select * from `educateplane` where ep_relationId=${ep_id} AND ep_checkStatus="待审核" AND (ep_isDelete IS NULL OR ep_isDelete="否")
         */},context,"");
        if(rr.length>0){
            rollback(con);
            closeconnection(con);
            return 1;
        }
        var result=multiexec(con,function(){/*
         INSERT INTO `educateplane` (
         `ep_id`,
         `ep_grade`,
         `ep_college`,
         `ep_major`,
         `ep_term`,
         `ep_courseid`,
         `courseCategory_1`,
         `ep_terrace`,
         `ep_checkway`,
         `ep_week`,
         `ep_note`,
         `ep_checkStatus`,
         `ep_checkType`,
         `ep_relationId`,
         `ep_setman`,
         `ep_settime`
         )
         values
         (UUID(),
         ${ep_grade},
         ${ep_college},
         ${ep_major},
         ${ep_term},
         ${courseId},
         ${courseCategory_1},
         ${ep_terrace},
         ${ep_checkway},
         ${ep_week},
         ${ep_note},
         "待审核",
         "删除",
         ${ep_id},
         ${sessionUserName},
         NOW())
         */},context);
        if(!result){
            rollback(con);
            closeconnection(con);
            return 3;
        }
    }else{
        var result = multiexec(con,"delete from educateplane where ep_id=${ep_id}",context);
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