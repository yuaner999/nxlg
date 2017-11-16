/**
 * Created by NEU on 2017/5/20.
 */
function main(context){
    //基础数据非空判断
    if(context.studentId == null||context.courseId == null||context.majorId == null||context.terraceId == null
        ||context.tc_class == null||context.studentNum == null){
        return false;
    }
    var r=query(function () {/*
     select semester from arrangecourse where is_now="1"
     */}, context,"");
    context.term=r[0].semester;
    //是否已经选了这门课
    var canselect1=query(function () {/*
     select *  from stuchoosecourse
     where studentId=${studentId} and courseId=${courseId} and term=${term}
     */}, context,"");
    if(canselect1.length>0){
        return {result: 1,errormessage: "这门课“已被选或待确认”，请选择其他课程"};
    }
    var canselect3=query(function () {/*
     select *  from stuchoosecourse
     where studentId=${studentId} and courseId=${courseId} and pass='已通过'
     */}, context,"");
    if(canselect3.length>0){
        return {result: 1,errormessage: "已经修过这门课了,选些其他的吧。"};
    }
    var result=exec(function(){/*
     INSERT INTO `nxlg`.`stuchoosecourse` (`scc`,`studentId`,`majorId`,`courseId`,`terraceId`,`class`,`studentNum`,`teacherName`,`courseCode`,`chineseName`,`term`,`tc_id`,istiaojicomfirm,iscomfirm)
     VALUES(uuid(),${studentId},${majorId},${courseId},${terraceId},${tc_class},${studentNum},${teacherName},${courseCode},${chineseName},${term},${tc_id},'0',"1") ;
     */},context);
    if(result){
        return {result: 0,errormessage:context.tc_teachmore};
    }else{
        return {result: 4};
    }
}
