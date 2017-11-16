/**
 * Created by NEUNB_Lisy on 2017/5/25.
 */
function main(context) {
    var result=querypagedata(function () {/*
     SELECT
     *
     FROM
     classroom
     WHERE
     classroom.`classroomId` NOT IN
     (
         SELECT arrangelesson.`classroomId`
         FROM
         arrangelesson
         LEFT JOIN `nxlg`.`teachtask`
         ON (`teachtask`.`tc_id`=`arrangelesson`.`tc_id`)
         LEFT JOIN `nxlg`.`arrangecourse`
         ON (`arrangecourse`.`acId`=`arrangelesson`.`acId`)
         WHERE
         is_now=1
         AND
         (
             (`al_timeweek`=${timeweek})
             AND (`al_timepitch`=${timepitch})
             AND (`tc_thweek_start`<=${teachweek} AND `tc_thweek_end`>=${teachweek})
             AND(`tc_teachodd`!=${teachodd})
         )
     )
    */},context,"",context.pageNum,context.pageSize);
    return result;
}