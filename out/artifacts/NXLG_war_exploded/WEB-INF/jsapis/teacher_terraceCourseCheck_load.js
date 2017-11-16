/**
 * Created by NEU on 2017/5/2.
 */
function main(context) {
    //专业平台课程设置
    var r =querypagedata(function () {/*
     SELECT
     `majorterracecourse`.*,`major`.*,`terrace`.*,`course`.*
     FROM
     `nxlg`.`majorterracecourse`
     LEFT JOIN `major`
     ON (`majorterracecourse`.`majorId` = `major`.`majorId`)
     LEFT JOIN `terrace`
     ON (`majorterracecourse`.`terraceId` = `terrace`.`terraceId`)
     LEFT JOIN `course`
     ON (`majorterracecourse`.`courseId` = `course`.`courseId`)
     WHERE (`majorterracecourse`.mtc_isDelete is null or `majorterracecourse`.mtc_isDelete="否")
     and (`major`.majorCollege LIKE CONCAT('%',${searchStr},'%')
        OR `major`.majorName LIKE CONCAT('%',${searchStr},'%')
        OR `major`.level LIKE CONCAT('%',${searchStr},'%')
        OR `terrace`.terraceName LIKE CONCAT('%',${searchStr},'%')
        OR `majorterracecourse`.mtc_courseTerm LIKE CONCAT('%',${searchStr},'%'))
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="1" then (`majorterracecourse`.mtc_checkStatus="已通过" or `majorterracecourse`.mtc_checkStatus="未通过") else 1=1 end
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="0" then `majorterracecourse`.mtc_checkStatus="待审核" else 1=1 end
     */}, context, "",context.pageNum,context.pageSize);
    return r;
}

    var inputsamples=[{
    }]
