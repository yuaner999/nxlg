/**
 * Created by NEU on 2017/6/12.
 */
function main(context) {
    var n= querypagedata(function () {/*
     SELECT
     `transferapply`.*, FROM_UNIXTIME(UNIX_TIMESTAMP(`transferapply`.setdate),'%Y-%m-%d %H:%i:%s') AS setdate
     , `student`.`studentNum`
     , `student`.`studentName`
     FROM
     `nxlg`.`transferapply`
     LEFT JOIN `nxlg`.`student`
     ON (`transferapply`.`studentId` = `student`.`studentId`)
     where (`student`.`studentNum` LIKE CONCAT('%',${searchStr},'%')
     OR `student`.`studentName` LIKE CONCAT('%',${searchStr},'%')
     OR `transferapply`.term LIKE CONCAT('%',${searchStr},'%')
     OR `transferapply`.studentMajor LIKE CONCAT('%',${searchStr},'%')
     OR `transferapply`.otherMajor LIKE CONCAT('%',${searchStr},'%')
     OR `transferapply`.status LIKE CONCAT('%',${searchStr},'%'))
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="1" then status="待审核" else 1=1 end
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="0" then (status="已通过" or status="已驳回") else 1=1 end
     order by setdate desc,convert(`transferapply`.status USING gbk) COLLATE gbk_chinese_ci
     */},context,"",context.pageNum,context.pageSize);
    return n;
}