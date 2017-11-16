
/**
 * Created by NEU on 2017/5/23.
 */
function main(context){
    var now=new Date();
    if(getsession(context,"sessionUserType")!="学生"){
        return 0;
    }
    var rrr=query(function(){/*
     SELECT * FROM `user` WHERE `userId`=${sessionUserID}
    */},context,'');
    if(rrr.length<1||rrr==null){
        return 1;
    }
    var rr= query(function () {/*
     SELECT a.wordbookValue AS thischoosestart,b.wordbookValue AS thischooseend,c.wordbookValue AS otherchoosestart,d.wordbookValue AS otherchooseend,
     e.wordbookValue AS tiaojistart,f.wordbookValue AS tiaojiend,g.wordbookValue AS thatchoosestart,h.wordbookValue AS thatchooseend,
     i.wordbookValue AS tiaojicomfirmstart,j.wordbookValue AS tiaojicomfirmend
     FROM wordbook a ,wordbook b,wordbook c ,wordbook d,wordbook e,wordbook f,wordbook g,wordbook h,wordbook i,wordbook j
     WHERE a.wordbookKey='本专业课程选课开始时间' AND b.`wordbookKey`='本专业课程选课结束时间'
     AND c.wordbookKey='其他专业课程选课开始时间' AND d.`wordbookKey`='其他专业课程选课结束时间'
     AND e.wordbookKey='调剂开始时间' AND f.`wordbookKey`='调剂结束时间'
     AND g.wordbookKey='辅修选课开始时间' AND h.`wordbookKey`='辅修选课结束时间'
     AND i.wordbookKey='调剂确认开始时间' AND j.`wordbookKey`='调剂确认结束时间'
     */},context,"thischoosestart,thischooseend,otherchoosestart,otherchooseend,tiaojistart,tiaojiend,thatchoosestart,thatchooseend,tiaojicomfirmstart,tiaojicomfirmend");
    if(rr[0].thischooseend>now||rr[0].otherchooseend>now||rr[0].tiaojiend>now||rr[0].thatchooseend>now||rr[0].tiaojicomfirmend>now){
        return 2;
    }
    context.studentId=rrr[0].typeId;
    var r=querypagedata(function () {/*
     SELECT
     `stuchoosecourse`.*
     , `course`.`courseCategory_3`
     , `terrace`.*
     , `course`.`courseCategory_4`
     , `course`.`courseCategory_5`
     , `student`.`studentName`,CONCAT(left(Areason,10),"......") as Arsn,CONCAT(left(Rreason,10),"......") as Rrsn
     FROM
     `nxlg`.`stuchoosecourse`
     LEFT JOIN `nxlg`.`course`
     ON (`stuchoosecourse`.`courseId` = `course`.`courseId`)
     LEFT JOIN `nxlg`.`terrace`
     ON (`stuchoosecourse`.`terraceId` = `terrace`.`terraceId`)
     LEFT JOIN `nxlg`.`student`
     ON (`stuchoosecourse`.`studentId` = `student`.`studentId`)
     WHERE `stuchoosecourse`.`studentId`=${studentId} and (`student`.`studentName` LIKE CONCAT('%',${searchStr},'%')
     or `stuchoosecourse`.`studentId` LIKE CONCAT('%',${searchStr},'%'))
     and case when (${filter} is not null and ${filter}<>"" and ${filter}="1") then (`stuchoosecourse`.`iscomfirm` = "1" and (`stuchoosecourse`.`scc_status` is null or `stuchoosecourse`.`scc_status` ='' or
     `stuchoosecourse`.`scc_status`="退课拒绝" )) else 1=1 end
     and case when (${filter} is not null and ${filter}<>"" and ${filter}="0") then (`stuchoosecourse`.`iscomfirm` = "1" and `stuchoosecourse`.`scc_status` is not null and `stuchoosecourse`.`scc_status` !='') else 1=1 end
     */},context,"",context.pageNum,context.pageSize);
    return r;
}
