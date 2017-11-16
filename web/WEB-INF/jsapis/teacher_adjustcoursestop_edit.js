/**
 * Created by NEU on 2017/6/5.
 */
function main(context) {
    //基础数据非空判断
    if(context.mac_id == null||context.now_timepitch == null ||context.now_timeweek == null||context.odd_teachweek == null){
        return false;
    }
    var rr = exec(function () {/*
     UPDATE 
     `nxlg`.`manualadjustcourse` 
     SET
     `odd_teachweek` = ${odd_teachweek},
     `now_timeweek` =${now_timeweek},
     `now_timepitch` =${now_timepitch},
     `settime` = NOW() 
     WHERE `mac_id` = ${mac_id};
     */}, context);
    return rr;
}
