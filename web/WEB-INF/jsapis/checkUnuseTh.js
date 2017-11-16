/**
 * Created by NEUNB_Lisy on 2017/5/25.
 */
function main(context) {
    var result=querypagedata(function () {/*
     SELECT
     *
     FROM
     `teacher`
     WHERE
     `teacher`.`teacherId` NOT IN
     (
         SELECT `checkth`.`teacherId`
         FROM `checkth`
         WHERE
         (`checkth`.`al_timeweek`=${timeweek})
     AND (`checkth`.`al_timepitch`=${timepitch})
     AND (`checkth`.`tc_thweek_start`<=${teachweek} AND `checkth`.`tc_thweek_end`>=${teachweek})
     AND(`checkth`.`tc_teachodd`!=${teachodd})
     )
     and `teacher`.`status` <> '离职' 
    */},context,"",context.pageNum,context.pageSize);
    return result;
}

var inputsamples=[
    {
        timeweek:"12"
    }
]