/**
 * Created by NEU on 2017/5/18.
 */
function main(context) {
    //sessionUserName非空判断
    if(getsession(context,"sessionUserName") == null){
        return false;
    }
    //基础数据非空判断
    if(context.CId == null||context.mainteacherid == null||context.tc_class == null||context.tc_classteacherid == null
        ||context.tc_studentnum == null||context.tc_numrange == null|| context.tc_teachway == null||context.tc_thweek_start == null
        ||context.tc_thweek_end == null||context.tc_teachodd == null){
        return false;
    }
    var term=query(function () {/*
     select semester from arrangecourse where is_now='1'
     */}, context,"");
    context.term=term[0].semester;
    console(term);
    context.tc_teachweek=context.tc_teachweek1+"至"+context.tc_teachweek2;
    context.tc_id=uuid();
    var rr = exec(function () {/*
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
     `tc_setman`,
     `tc_settime`,
     `tc_semester`
     )
     VALUES
     (
     ${tc_id},
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
     "新增",
     "待审核",
     ${sessionUserName},
     NOW(),
     ${term}
     ) ;
     */}, context);
    return {rr:rr,tc_id:context.tc_id};
}
