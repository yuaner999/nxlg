/**
 * Created by NEU on 2017/4/18.
 */
function main(context){
    //sessionUserID非空判断
    if(getsession(context,"sessionUserID") == null){
        return false;
    }
//基础数据非空判断
    if(context.terraceId == null||context.courseId == null||context.tc_class == null||context.tc_teachweek == null||context.tc_teachodd == null){
        return false;
    }
    var is=false;
    var t=query(function () {/*
     SELECT
     a.majorId AS amajorId,`user`.*, `student`.*
     FROM `user`
     LEFT JOIN `student` ON (`user`.`typeId` = `student`.`studentId`)
     LEFT JOIN major a ON a.majorName=student.studentMajor
     WHERE `user`.`typeName`="学生" AND `user`.`userId`=${sessionUserID}
     AND a.`checkStatus`='已通过' AND (ISNULL(a.`isDelete`) OR (a.`isDelete` = '否'))
     */}, context,"");
    if(t.length<=0){
        return {result: 1,errormessage: "没有您的信息"};
    }
    context.studentId=t[0].studentId;
    context.studentGrade=t[0].studentGrade;
    context.studentMajor=t[0].studentMajor;
    context.stumajorId=t[0].amajorId;
    context.stuothermajor=t[0].otherMajor;
    context.othermajorId="";
    if(context.stuothermajor!=null&&context.stuothermajor!=""){
        var stuothermajor=query(function () {/*
         select majorId from major where majorName=${stuothermajor}
         AND  (`major`.`checkStatus` = '已通过') AND (ISNULL(`major`.`isDelete`) OR (`major`.`isDelete` = '否'))
         */}, context,"");
        if(stuothermajor.length>0){
            context.othermajorId=stuothermajor[0].majorId;
        }
    }
    var r=query(function () {/*
     select semester from arrangecourse where is_now="1"
     */}, context,"");
    context.term=r[0].semester;
    context.term1=context.term.substring(context.term.length-4,context.term.length);
    var canselect3=query(function () {/*
     select *  from stuchoosecourse
     where studentId=${studentId} and courseId=${courseId} and pass='已通过'
     */}, context,"");
    if(canselect3.length>0){
        return {result: 1,errormessage: "你已经修过这门课了,选些其他的吧。"};
    }
    //是否已经选了这门课
    var canselect1=query(function () {/*
     select *  from stuchoosecourse
     where studentId=${studentId} and courseId=${courseId} and term=${term}
     */}, context,"");
    if(canselect1.length>0){
        return {result: 1,errormessage: "你已经选择这门课了,选些其他的吧。"};
    }
    //是否有专属课程 (这学期,这门课)
    var qianti=query(function () {/*
     select * from majorterracecourse where mtc_grade=${studentGrade} and majorId=${stumajorId} and  mtc_courseTerm=${term} and courseId=${courseId}
     AND mtc_checkStatus='已通过' AND (ISNULL(mtc_isDelete) OR (mtc_isDelete= '否'))
     */}, context,"");
    if(qianti.length>0) {
        var canselect21 = query(function () {/*
         select teachtask.* ,tcmajor.* from teachtask
         left join tcmajor on tcmajor.tcm_tc_id =teachtask.tc_id
         where tc_semester=${term} and tcm_majorid=${stumajorId} and tc_courseid=${courseId} and tcm_grade=${studentGrade}
         and (`tc_isDelete` IS NULL OR `tc_isDelete`='否') AND `tc_checkStatus`='已通过'
         */}, context, "");
        if (canselect21.length > 0) {
            for (var i = 0; i < canselect21.length; i++) {
                if (context.tcm_id == canselect21[i].tcm_id) {
                    is = true;
                    break;
                }
                if (i == canselect21.length - 1) {
                    return {result: 1, errormessage: "请选择该课您的主修专业专属班级"};
                }
            }
        }
        if(canselect21.length==0){
            return {result: 1, errormessage: "已经为您的主修专业开设了此课程,教师未进行课程分班，请及时联系教师"};
        }
    }else{
        if(context.othermajorId != null && context.othermajorId != "" && is == false){
            var qiantiother=query(function () {/*
             select * from majorterracecourse where mtc_grade=${studentGrade} and majorId=${othermajorId} and  mtc_courseTerm=${term} and courseId=${courseId}
             AND (mtc_checkStatus='已通过') AND (ISNULL(mtc_isDelete) OR (mtc_isDelete= '否'))
             */}, context,"");
            if(qiantiother.length>0){
                var canselect31 = query(function () {/*
                 select teachtask.* ,tcmajor.* from teachtask
                 left join tcmajor on tcmajor.tcm_tc_id =teachtask.tc_id
                 where tc_semester=${term} and tcm_majorid=${othermajorId} and tc_courseid=${courseId}  and tcm_grade=${studentGrade}
                 and (`tc_isDelete` IS NULL OR `tc_isDelete`='否') AND `tc_checkStatus`='已通过'
                 */}, context, "");
                if (canselect31.length > 0) {
                    for (var i = 0; i < canselect31.length; i++) {
                        if (context.tcm_id == canselect31[i].tcm_id) {
                            break;
                        }
                        if (i == canselect31.length - 1) {
                            return {result: 1, errormessage: "请选择该课您的辅修专业专属班级"};
                        }
                    }
                }
                if(canselect31.length==0){
                    return {result: 1, errormessage: "已经为您的辅修专业开设了此课程,教师未进行课程分班，请及时联系教师"};
                }
            }
        }
    }
    // 是否人数超限
    var totolpeople=query(function () {/*
     select count(studentId) as countstudentId from stuchoosecourse where tc_id=${tc_id} and term=${term}
     */}, context,"");
    var tc_numrange=query(function () {/*
     select tc_numrange from teachtask where tc_id=${tc_id}
     */}, context,"");
    if(totolpeople.length>0){
        if(parseInt(totolpeople[0].countstudentId)>=parseInt(tc_numrange[0].tc_numrange)){
            return {result: 3,errormessage: "人数超限，请选择其他班级"};
        }
    }
    //是否达到开课人数
    var tc_studentnum=query(function () {/*
     select tc_studentnum from teachtask where tc_courseid=${courseId} and tc_class=${tc_class}
     */}, context,"");
    if(totolpeople.length>0){
        if(parseInt(totolpeople[0].countstudentId)<parseInt(tc_studentnum[0].tc_studentnum)){
            //console(totolpeople[0].countstudentId+'已选大于总人数'+tc_studentnum[0].tc_studentnum);
            return {result: 3,errormessage: "人数未到达开课人数，请选择其他班级"};
        }
    }else{
        return {result: 3,errormessage: "人数未到达开课人数，请选择其他班级"};
    }

    // 先查这学期的课 是否周重叠 周不重复 直接选 周重复需要判断星期几和节次是否重复 重复了
    var canselect2=query(function () {/*
     SELECT `teachtask`.`tc_teachweek`, `teachtask`.`tc_teachodd`, `teachtask`.`tc_id` , `arrangelesson`.`al_timeweek`
     , `arrangelesson`.`al_timepitch`, `stuchoosecourse`.`term` , `stuchoosecourse`.`courseId`,stuchoosecourse.chineseName
     FROM `nxlg`.`stuchoosecourse`
     LEFT JOIN `nxlg`.`teachtask`
     ON (`stuchoosecourse`.`tc_id` = `teachtask`.`tc_id`)
     LEFT JOIN `nxlg`.`arrangelesson`
     ON (`teachtask`.`tc_id` = `arrangelesson`.`tc_id`)
     where studentId=${studentId}  and stuchoosecourse.term=${term}
     */}, context,"tc_teachweek,tc_teachodd,tc_id,times:[al_timeweek,jie:[al_timepitch]],term,courseId,chineseName");
    for(var j=0;j<canselect2.length;j++){
            if(canselect2[j].tc_thweek_start<=context.tc_thweek_end && context.tc_thweek_start<=canselect2[j].tc_thweek_end){
                if(context.tc_teachodd=='无'||canselect2[j].tc_teachodd=='无'||(context.tc_teachodd==canselect2[j].tc_teachodd)){
                    // console(contextteachweek[z]+'与'+parseInt(contextteachweek[j])+"周冲突,接下来检查星期节次是否重复");
                    for(var k=0;k<canselect2[j].times.length;k++)
                    {
                        for(var h=0;h<context.times.length;h++){
                            //如果星期不重复，那么节次也不用检查了
                            if(parseInt(context.times[h].al_timeweek)==canselect2[j].times[k].al_timeweek){
                                // console(context.times[h].al_timeweek+"冲突了"+canselect2[j].times[k].al_timeweek+"查看节次是否冲突") ;
                                //console('节次length'+canselect2[j].times[k].jie.length);
                                for(var l=0;l<canselect2[j].times[k].jie.length;l++){
                                    for(var m=0;m<context.times[h].jie.length;m++){
                                        if(parseInt(context.times[h].jie[m].al_timepitch)==canselect2[j].times[k].jie[l].al_timepitch){
                                            //console(context.times[h].jie[m].al_timepitch+'与'+canselect2[j].times[k].jie[l].al_timepitch+"冲突");
                                            return {result: 2,errormessage:"时间冲突了",row:canselect2[j].chineseName};
                                        }//else{
                                        // console(context.times[h].jie[m].al_timepitch+'与'+canselect2[j].times[k].jie[l].al_timepitch+"不冲突");
                                        // }
                                    }
                                }
                            }//else{
                            // console("第"+h+'xingqi'+context.times[h].al_timeweek+'与'+canselect2[j].times[k].al_timeweek+"不冲突")
                            // }
                        }
                    }

                }
            }//else {
            // console('第'+z+'个'+contextteachweek[z]+'不在'+canselect2teachweek[j][0]+'于'+canselect2teachweek[j][1]+'内');
            //  }
    }
    context.studentNum=t[0].studentNum;
    var result=exec(function(){/*
     INSERT INTO `nxlg`.`stuchoosecourse` (`scc`,`studentId`,`majorId`,`courseId`,`terraceId`,`class`,`studentNum`,`teacherName`,`courseCode`,`chineseName`,`term`,`tc_id`,iscomfirm,istiaojicomfirm,pass)
     VALUES(uuid(),${studentId},${majorId},${courseId},${terraceId},${tc_class},${studentNum},${teacherName},${courseCode},${chineseName},${term},${tc_id},'2','0','选修中') ;
     */},context);
    if(result){
        return {result: 0,errormessage:context.tc_teachmore};
    }else{
        return {result: 4};
    }
}
var inputsamples=[{
    sessionUserID:'b69d5e95-3a1d-11e7-b0f2-00ac9c2c0afa',
    courseId:'4df105c9-5f4b-4dd6-b886-8eb63de437a9',
    terraceId:'1fd3def8-2415-11e7-be40-00ac9c2c0afa',
    tc_class:'数学1班',
    tc_teachweek:'1至12',
    tc_teachodd:'单',
    times:[{
        al_timeweek:'4',
        jie:[{al_timepitch:'1'},{al_timepitch:'2'}]
    },{
        al_timeweek:'2',
        jie:[{al_timepitch:'1'},{al_timepitch:'2'}]
    }
    ]
}]
