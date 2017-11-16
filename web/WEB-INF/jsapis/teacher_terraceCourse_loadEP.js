/**
 * Created by NEU on 2017/5/19.
 * 加上group by去掉重复
 */
function main(context) {
    var term=query(function(){/*
     SELECT * FROM `arrangecourse` WHERE is_now="1"
    */},context,"");
    context.term=term[0].semester.substr(9,12);
    var r =querypagedata(function () {/*
     SELECT
     `educateplane`.*, `course`.*
     FROM
     `nxlg`.`educateplane`
     LEFT JOIN `nxlg`.`course`
     ON (`educateplane`.`ep_courseid` = `course`.`courseId`)
     WHERE `educateplane`.ep_college=${majorCollege} and ep_major=${ep_major}
     and `educateplane`.ep_terrace=${terraceName}
     and `educateplane`.ep_term=${term}
     and (`educateplane`.ep_isset<>"1" or `educateplane`.ep_isset is null)
     and(`educateplane`.ep_isDelete is null or `educateplane`.ep_isDelete="否")
     and `educateplane`.ep_checkStatus="已通过"
      */}, context, "",context.pageNum,context.pageSize);
    return r;
}
