/**
 * Created by NEUNB_Lisy on 2017/5/19.
 */
//查询该教室的课程表
function main(context) {
    var result = querypagedata(function () {/*
     SELECT
     `arrangelesson`.*,
     `course`.*,
     `teachtask`.*,
     `teacher`.*
     FROM
     `nxlg`.`arrangelesson`
     LEFT JOIN `nxlg`.`course`
     ON (`arrangelesson`.`courseId`=`course`.`courseId`)
     LEFT JOIN `nxlg`.`teachtask`
     ON (`teachtask`.`tc_id`=`arrangelesson`.`tc_id`)
     LEFT JOIN `nxlg`.`teacher`
     ON (`teacher`.`teacherId`=`teachtask`.`tc_classteacherid`)
     LEFT JOIN `nxlg`.`arrangecourse`
     ON (`arrangelesson`.`acId`=`arrangecourse`.`acId`)
     WHERE
     `is_now`=1 AND  `classroomId`=${classroomId} AND (tc_teachodd='无' OR ${thweekday}=0  OR tc_teachodd=${teachodd}) AND (${thweekday}=0 OR (tc_thweek_start<=${thweekday} AND ${thweekday}<=tc_thweek_end))
     */},context,"");
    return result;
}

/*
var inputsamples=[
    {
        classroomId:"e08682f0-1086-11e7-bdbc-00ac9c2c0afa"
    }
]*/
