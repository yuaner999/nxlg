/**
 * Created by NEUNB_Lisy on 2017/5/17.
 * 根据ID值查找空余教室
 */

function main(context) {
    context.userId = getsession(context,"sessionUserID");
    var r=query(function () {/*
     SELECT * FROM `user` WHERE userId=${userId}
    */},context,"");
    context.Id=r[0].typeId;
     var result = query(function () {/*
      select
      *,
      sum(score)as totalscore
      from
      (select
      t.courseId,
      t.terraceId,
      t.majorId,
      (select
      c.totalCredit
      from
      course c
      where c.courseId = t.courseId) as score,
      (select
      te.terraceName
      from
      terrace te
      where te.terraceId = t.terraceId) as rterraceName
      from
      stuchoosecourse t
      where t.iscomfirm = 1
      and studentId = ${Id}
      and t.majorId = ${majorId}
      AND (
      t.scc_status != '退课通过'
      or t.scc_status is null  OR t.scc_status =''
      )) as a
      group by terraceId
      */},context,"");
     return result;
}
