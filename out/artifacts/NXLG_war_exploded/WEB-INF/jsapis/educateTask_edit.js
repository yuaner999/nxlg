/**
 * Created by NEU on 2017/5/18.
 */
function main(context){
    //sessionUserName非空判断
    if(getsession(context,"sessionUserName") == null){
        return false;
    }
    //基础数据非空判断
    if(context.CId == null||context.mainteacherid == null||context.tc_class == null||context.tc_classteacherid == null
        ||context.tc_studentnum == null||context.tc_numrange == null|| context.tc_teachway == null||context.tc_thweek_start == null
        ||context.tc_thweek_end == null||context.tc_teachodd == null||context.tc_teachmore == null){
        return false;
    }
    //修改
    var term=query(function () {/*
     select semester from arrangecourse where is_now='1'
     */}, context,"");
    context.term=term[0].semester;
    var con = createconnection();
    if(context.tc_checkStatus=='已通过'){//已通过，修改时新建一条数据
        var rr=query(function(){/*
         select * from `teachtask` where tc_relationId=${tc_id} AND tc_checkStatus="待审核" AND (tc_isDelete IS NULL OR tc_isDelete="否")
         */},context,"");
        if(rr.length>0){
            rollback(con);
            closeconnection(con);
            return 1;
        }
        context.tc_id2=uuid();
        var result=multiexec(con,function(){/*
         INSERT INTO `nxlg`.`teachtask` (
         `tc_id`,
         `tc_courseid`,
         `tc_mainteacherid`,
         `tc_class`,
         `tc_classteacherid`,
         `tc_studentnum`,
         `tc_numrange`,
         `tc_teachway`,
         `tc_thweek_start`,
         `tc_thweek_end`,
         `tc_teachodd`,
         `tc_teachmore`,
         `tc_checkType`,
         `tc_checkStatus`,
         `tc_relationId`,
         `tc_setman`,
         `tc_settime`,  
         tc_semester
         )
         VALUES
         (
         ${tc_id2},
         ${CId},
         ${mainteacherid},
         ${tc_class},
         ${tc_classteacherid},
         ${tc_studentnum},
         ${tc_numrange},
         ${tc_teachway},
         ${tc_thweek_start},
         ${tc_thweek_end},
         ${tc_teachodd},
         ${tc_teachmore},
         "修改",
         "待审核",
         ${tc_id},
         ${sessionUserName},
         NOW(),
         ${term}
         )
         */},context);
        if(!result){
            rollback(con);
            closeconnection(con);
            return 3;
        }
        commit(con);
        closeconnection(con);
        return {rr:2,tc_id:context.tc_id2};
    }else{
        var result =multiexec(con,function () {/*
         UPDATE
         `teachtask`
         SET
         `tc_class`= ${tc_class},
         `tc_classteacherid`= ${tc_classteacherid},
         `tc_studentnum`= ${tc_studentnum},
         `tc_numrange`= ${tc_numrange},
         `tc_teachway`= ${tc_teachway},
         `tc_thweek_start`= ${tc_thweek_start},
         `tc_thweek_end`= ${tc_thweek_end},
         `tc_teachodd`= ${tc_teachodd},
         `tc_teachmore`= ${tc_teachmore},
         `tc_checkType`= "修改",
         `tc_checkStatus`="待审核",
         `tc_setman`= ${sessionUserName},
         `tc_settime`=NOW()
         WHERE `tc_id`= ${tc_id};
         delete from tcmajor where tcm_tc_id=${tc_id};
         */},context);
        if(!result){
            rollback(con);
            closeconnection(con);
            return 3;
        }
        commit(con);
        closeconnection(con);
        return {rr:2,tc_id:context.tc_id};
    }
}
var inputsamples=[{
    majorName:"qqq",
    checkStatus:"待审核"
}]