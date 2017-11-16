/**
 * Created by NEU on 2017/5/18.
 */
function main(context){
    var con = createconnection();
    if (context.tc_checkStatus=='已通过'){
        var r=query(function () {/*
         select * from `teachtask` where tc_relationId=${tc_id} AND tc_checkStatus="待审核" AND (tc_isDelete IS NULL OR tc_isDelete="否")
         */},context,"");
        if(r.length>0){
            return 2;
        }
        var result=multiexec(con,function(){/*
         INSERT INTO `nxlg`.`teachtask` (`tc_id`, `tc_courseid`, `tc_mainteacherid`,`tc_class`,`tc_classteacherid`,
         `tc_studentnum`, `tc_numrange`,`tc_teachway`,`tc_thweek_start`,`tc_thweek_end`,
         `tc_teachodd`,`tc_teachmore`,`tc_checkType`,`tc_checkStatus`,`tc_relationId`,`tc_setman`,
         `tc_settime`)
         VALUES( UUID(),${courseId},${mainteacherid},${tc_class},${tc_classteacherid},
         ${tc_studentnum},${tc_numrange}, ${tc_teachway},${tc_thweek_start}, ${tc_thweek_end},
         ${tc_teachodd}, ${tc_teachmore}, "删除","待审核",${tc_id},
         ${sessionUserName}, NOW())
         */},context,"");
        if(!result){
            rollback(con);
            closeconnection(con);
            return false;
        }
    }else {
        var result=multiexec(con,function(){/*
         delete from teachtask where tc_id=${tc_id};
         */},context);
        if(!result){
            rollback(con);
            closeconnection(con);
            return false;
        }
        var r2=multiexec(con,function(){/*
         delete from tcmajor where tcm_tc_id=${tc_id};
         */},context);
        if(!r2){
            rollback(con);
            closeconnection(con);
            return false;
        }
    }
    commit(con);
    closeconnection(con);
    return true;
}
