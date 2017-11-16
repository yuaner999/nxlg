/**
 * Created by NEU on 2017/4/28.
 */
function main(context){
    //sessionUserName非空判断
    if(getsession(context,"sessionUserName") == null){
        return false;
    }
    //基础数据非空判断
    if(context.ep_grade == null||context.ep_college == null||context.ep_major == null||context.ep_term == null
        ||context.courseId == null||context.courseCategory_1 == null||context.ep_terrace == null){
        return false;
    }
    var valid=query(function(){/*
     SELECT * FROM `educateplane` WHERE `ep_grade`=${ep_grade} and
     `ep_college`=${ep_college} and
     `ep_major`=${ep_major} and
     `ep_term`=${ep_term} and
     ep_courseid=${ep_courseid} and
     `courseCategory_1`=${courseCategory_1} and
     `ep_terrace`=${ep_terrace} and (ep_id<>${ep_id} and ep_id<>${ep_relationId})and (ep_isDelete IS NULL OR ep_isDelete="否")
     */},context,"");
    console(valid);
    if(valid.length>0){
        return 0;
    }else{
        /*限制一个课程只能属于本年级的某一个平台里。*/
        var gradeTerCourse=query(function(){/*
         SELECT ep_terrace FROM `educateplane` WHERE `ep_grade`=${ep_grade} and
         ep_courseid = ${ep_courseid} and (ep_isDelete IS NULL OR ep_isDelete="否")
         */},context,"");
        if(gradeTerCourse.length>0&&gradeTerCourse[0].ep_terrace!=context.ep_terrace){
            return 9;
        }else{
            //修改
            var con = createconnection();
            if(context.ep_checkStatus=='已通过'){//已通过，修改时新建一条数据
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
                 ${ep_courseid},
                 ${courseCategory_1},
                 ${ep_terrace},
                 ${ep_checkway},
                 ${ep_week},
                 ${ep_note},
                 "待审核",
                 "修改",
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
                var result =multiexec(con,function () {/*
                 UPDATE
                 `educateplane`
                 SET
                 `ep_grade`=${ep_grade},
                 `ep_college`=${ep_college},
                 `ep_major`=${ep_major},
                 `ep_term`=${ep_term},
                 `ep_courseid`=${ep_courseid},
                 `courseCategory_1`=${courseCategory_1},
                 `ep_terrace`=${ep_terrace},
                 `ep_checkway`=${ep_checkway},
                 `ep_week` =  ${ep_week},
                 `ep_note` =  ${ep_note},
                 `ep_checkStatus` ="待审核",
                 `ep_refuseReason`=NULL,
                 `ep_setman` = ${sessionUserName},
                 `ep_settime` = NOW()
                 WHERE `ep_id` = ${ep_id}
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
    }
}
var inputsamples=[{
    mtc_id:"2"
}]