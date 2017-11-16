/**
 * Created by NEU on 2017/6/6.
 */
function main(context){
    var semester=query(function () {/*
     select semester from arrangecourse where is_now="1"
     */}, context,"");
    context.term=semester[0].semester;
    //学生
    var rr =querypagedata(function () {/*
     select stuchoosecourse.*,student.studentGrade,student.studentNum,studentName,student.studentMajor,stuchoosecourse.pass,scc
      from stuchoosecourse
     left join student on student.studentId=stuchoosecourse.studentId
     left join teachtask on stuchoosecourse.tc_id=teachtask.tc_id
     WHERE  term=${term} and (`teachtask`.`tc_isDelete` IS NULL OR `teachtask`.`tc_isDelete` ="否") AND `tc_checkStatus`='已通过'
     and stuchoosecourse.iscomfirm='1' AND (scc_status!='退课通过' OR scc_status IS NULL)
     and stuchoosecourse.tc_id=${tc_id}
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="1" then pass="已通过" else 1=1 end
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="0" then pass = "选修中"else 1=1 end
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="2" then pass="未通过" else 1=1 end
     */}, context, "",context.pageNum,context.pageSize);
    return rr;
}