/**
 * Created by NEU on 2017/3/18.
 */
function main(context){
    //sessionUserName非空判断
    if(getsession(context,"sessionUserName") == null){
        return false;
    }
    //基础数据非空判断
    if(context.majorCollege == null ||context.majorName == null ||context.internationalCode == null ||context.majorCode == null ||context.subject == null ||
        context.level == null ||context.length == null ||context.settingYear == null ){
        return false;
    }
    //修改
    var con = createconnection();
    var json="[{院(系)/部："+context.majorCollege+"},{国标专业个数："+context.internationalNum+"},{国标专业代码："
        +context.internationalCode+"},{专业代码："+context.majorCode+"},{专业名称："+context.majorName+"},{所属学科："+context.subject+"},{培养层次："
        +context.level+"},{学制："+context.length+"},{设置年份："+context.settingYear+"},{专业状态："+context.majorStatus+"},{培养对象："
        +context.trainingobjects+"},{专业简介："+context.introduction+"}]";
    context.json=json;
    //判断是否重复，院系、专业
    var valid=query(function(){/*
     SELECT * FROM `major` WHERE `majorCollege`=${majorCollege} and `majorName`=${majorName}  and majorId<>${majorId} and (isDelete is null or isDelete="否")
     and relationId<>${majorId}
     */},context,"");
    if(valid.length>0){
        return 0;
    }
    if(context.checkStatus=='已通过'){//已通过，修改时新建一条数据
        var rr=query(function(){/*
         select * from `major` where relationId=${majorId} AND checkStatus="待审核" AND (isDelete IS NULL OR isDelete="否")
         */},context,"");
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
         `checkStatus`,
         `checkType`,
         `relationId`,
         `updateMan`,
         `updateDate`,
         trainingobjects,
         introduction
         ) VALUES(UUID(),${majorCollege},${internationalNum},${internationalCode},${majorCode},
         ${majorName},${subject},${level},${length},${settingYear},${majorStatus},"待审核","修改",${majorId},${sessionUserName},NOW(),${trainingobjects},${introduction})
         */},context);
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
         `before`,
         `after`
         )
         VALUES
         (
         UUID(),
         ${majorId},
         NOW(),
         "修改",
         "待审核",
         ${json1},
         ${json}
         )
         */},context);
        if(!r){
            rollback(con);
            closeconnection(con);
            return 3;
        }
    }else{
        var result =multiexec(con,function () {/*
         UPDATE
         `major`
         SET
         `majorCollege` = ${majorCollege},
         `internationalNum` = ${internationalNum},
         `internationalCode` = ${internationalCode},
         `majorCode` = ${majorCode},
         `subject` = ${subject},
         `majorName` = ${majorName},
         `length` = ${length},
         `settingYear` = ${settingYear},
         `level` = ${level},
         `checkStatus`="待审核",
         `refuseReason`=NULL,
         `updateMan` = ${sessionUserName},
         `updateDate` = NOW(),
         trainingobjects = ${trainingobjects},
         introduction = ${introduction}
         WHERE `majorId` = ${majorId};
         */},context);
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
         `before`,
         `after`
         )
         VALUES
         (
         UUID(),
         ${majorId},
         NOW(),
         "修改",
         "待审核",
         ${json1},
         ${json}
         )
         */},context);
        if(!r){
            rollback(con);
            closeconnection(con);
            return 3;
        }
    }
    commit(con);
    closeconnection(con);
    return 2;
}
var inputsamples=[{
    majorName:"qqq",
    checkStatus:"待审核"
}]