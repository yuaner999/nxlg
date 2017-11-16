/**
 * Created by NEU on 2017/6/8.
 */
function main(context) {
    var t=query(function () {/*
     SELECT
     `user`.*, `student`.*
     FROM `user`
     LEFT JOIN `student` ON (`user`.`typeId` = `student`.`studentId`)
     WHERE `user`.`typeName`="学生" AND `user`.`userId`=${sessionUserID}
     */}, context,"");
    context.studentId=t[0].studentId;
    //在该平台需修满学分
    var n= query(function () {/*
     SELECT stuchoosecourse.`studentId`,SUM(course.`totalCredit`) AS total,stuchoosecourse.`terraceId`,terrace.`terraceName`,major.`majorId`,scoretotal,(scoretotal-SUM(course.`totalCredit`) ) AS leftcredit
     FROM majorterracescore
     LEFT JOIN major ON (majorterracescore.`majorId`=major.`majorId`)
     LEFT JOIN student ON ( student.`studentMajor`=major.`majorName`)
     LEFT JOIN terrace ON terrace.`terraceId`=majorterracescore.`terraceId`
     LEFT JOIN stuchoosecourse ON (majorterracescore.`terraceId` = stuchoosecourse.`terraceId` AND student.`studentId`=stuchoosecourse.`studentId` AND stuchoosecourse.`pass`="已通过" AND iscomfirm='1' AND (scc_status!='退课通过' OR ISNULL(scc_status)))
     LEFT JOIN course ON course.`courseId`=stuchoosecourse.`courseId`
     WHERE student.studentId=${studentId} AND `major`.`checkStatus` = '已通过' AND ( ISNULL(`major`.`isDelete`) OR (`major`.`isDelete` = '否') )
     GROUP BY majorterracescore.`terraceId`
     */},context,"");
    for(var i=0;i<n.length;i++){
        if(n[i].total==''||n[i].total==null){
            n[i].total=0;
            n[i].leftcredit=n[i].scoretotal;
        }
    }
    return n;
}
inputsamples=[{
    sessionUserID:'b69d5e95-3a1d-11e7-b0f2-00ac9c2c0afa'
}]
