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
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="2" then (`majorterracecourse`.mtc_checkStatus="已通过" ) else 1=1 end
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="3" then (`majorterracecourse`.mtc_checkStatus="未通过") else 1=1 end
     and case when ${filter} is not null and ${filter}<>"" and ${filter}="1" then `majorterracecourse`.mtc_checkStatus="待审核" else 1=1 end
     and `majorterracecourse`.mtc_grade LIKE ${grade} and `major`.majorCollege LIKE ${college} and `major`.majorName LIKE ${major}
     and case when ${checkType} is not null and ${checkType}<>""  then `majorterracecourse`.mtc_checkType = ${checkType} else 1=1 end
     and case when ${terraceName} is not null and ${terraceName}<>""  then terrace.terraceId=${terraceName} else 1=1 end
     and case when ${majorLevel} is not null and ${majorLevel}<>""  then major.level=${majorLevel} else 1=1 end
     and case when ${termName} is not null and ${termName}<>""  then mtc_courseTerm = ${termName} else 1=1 end
     */}, context, "",context.pageNum,context.pageSize);
    return r;
}

    var inputsamples=[{
    }]
