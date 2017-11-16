/**
 * Created by NEU on 2017/3/18.
 */
function main(contexts){
    //删除
    var con=createconnection();
    for(var i=0;i<contexts.passIds.length;i++){
        var majorId = contexts.passIds[i].majorId;
        var majorCollege = contexts.passIds[i].majorCollege;
        var internationalCode = contexts.passIds[i].internationalCode;
        var internationalNum = contexts.passIds[i].internationalNum;
        var majorCode = contexts.passIds[i].majorCode;
        var majorName = contexts.passIds[i].majorName;
        var subject = contexts.passIds[i].subject;
        var level = contexts.passIds[i].level;
        var length = contexts.passIds[i].length;
        var settingYear = contexts.passIds[i].settingYear;
        var majorStatus = contexts.passIds[i].majorStatus;

        var json="[{院(系)/部："+majorCollege+"},{国标专业个数："+internationalNum+"},{国标专业代码："
            +internationalCode+"},{专业代码："+majorCode+"},{专业名称："+majorName+"},{所属学科："+subject+"},{培养层次："
            +level+"},{学制："+length+"},{设置年份："+settingYear+"},{专业状态："+majorStatus+"}]";
        if(contexts.passIds[i].checkStatus=='已通过'){
            var rr=query(function(){/*
             select * from `major` where relationId=${majorId} AND checkStatus="待审核" AND (isDelete IS NULL OR isDelete="否")
             */},{majorId:majorId},"");
            if(rr.length>0){
                rollback(con);
                closeconnection(con);
                return 1;
            }
            var result=multiexec(con,function(){/*
             INSERT INTO `major` (
             `majorId`,
             `majorCollege`,
             `internationalNum`,
             `internationalCode`,
             `majorCode`,
             `majorName`,
             `subject`,
             `level`,
             `length`,
             `settingYear`,
             `majorStatus`,
             `checkType`,
             `checkStatus`,
             `relationId`,
             `updateMan`,
             `updateDate`
             ) VALUES(UUID(),${majorCollege},${internationalNum},${internationalCode},${majorCode},
             ${majorName},${subject},${level},${length},${settingYear},${majorStatus},"删除","待审核",${majorId},${sessionUserName},NOW())
             */},{majorCollege:majorCollege,internationalNum:internationalNum,internationalCode:internationalCode,majorCode:majorCode,majorName:majorName,subject:subject,
                level:level,length:length,settingYear:settingYear,majorStatus:majorStatus});
            if(!result){
                rollback(con);
                closeconnection(con);
                return 3;
            }
            var r=multiexec(con,function(){/*
             INSERT INTO `majorrecord` (
             `id`,
             `majorId`,
             `time`,
             `type`,
             `result`,
             `before`
             )
             VALUES
             (
             UUID(),
             ${majorId},
             NOW(),
             "删除",
             "待审核",
             ${json}
             )
             */},{majorId:majorId,json:json});
            if(!r){
                rollback(con);
                closeconnection(con);
                return 3;
            }
        }else{
            var result = multiexec(con,function(){/*
             delete from major where majorId=${majorId};
             */},{majorId:majorId});
            if(!result){
                rollback(con);
                closeconnection(con);
                return 3;
            }
            var r=multiexec(con,function(){/*
             INSERT INTO `majorrecord` (
             `id`,
             `majorId`,
             `time`,
             `type`,
             `result`,
             `before`
             )
             VALUES
             (
             UUID(),
             ${majorId},
             NOW(),
             "删除",
             "待审核",
             ${json}
             )
             */},{majorId:majorId,json:json});
            if(!r){
                rollback(con);
                closeconnection(con);
                return 3;
            }
        }
    }
    commit(con);
    closeconnection(con);
    return 2;
}