
function main(context) {
    context.userId = getsession(context,"sessionUserID");
    var r=query(function () {/*
     SELECT * FROM `user` WHERE userId=${userId}
     */},context,"");
    context.Id=r[0].typeId;
    var result = query(function () {/*
     select
     *
     from
     stuchoosecourse t
     left join course c
     on t.courseId = c.courseId
     WHERE t.iscomfirm = 1
     and studentId = ${Id}
     and t.majorId = ${majorId}
     AND (
     t.scc_status != '退课通过'
     OR t.scc_status IS NULL
     )
     and terraceId = ${terraceId}
     */},context,"");
    return result;
}
