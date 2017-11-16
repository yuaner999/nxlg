/**
 * Created by NEU on 2017/6/23.
 */
function main(context) {
    var r = query(function () {/*
     SELECT
     `course`.`assumeUnit`
     FROM
     `nxlg`.`majorterracecourse`
     LEFT JOIN `nxlg`.`course`
     ON (`majorterracecourse`.`courseId` = `course`.`courseId`)
     WHERE
     `majorterracecourse`.`mtc_id`=${mtc_id}
     */}, context, "");
    if (r.length < 1) {
        return 1;
    } else {
        context.assumeUnit = r[0].assumeUnit;
    }
    //console(context.assumeUnit);
    var result = query(function () {/*
     SELECT
     b.teacherId as bteacherId,b.teacherName as bteacherName
     FROM
     `teacher` b
     WHERE
     b.`teachCollege`=${assumeUnit}
     */}, context, "");
    console(result);
    if (result.length < 1) {
        return 1;
    } else {
        return result;
    }
}