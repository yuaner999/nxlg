/**
 * Created by NEU on 2017/3/18.
 */
function main(context) {
    //sessionUserName非空判断
    if(getsession(context,"sessionUserName") == null){
        return false;
    }
    //基础数据非空判断
    if(context.majorCollege == null ||context.majorName == null ||context.internationalCode == null ||context.majorCode == null ||context.subject == null ||
        context.level == null ||context.length == null ||context.settingYear == null ){
        return false;
    }
    //启用
    var con = createconnection();
    var json="[{院(系)/部："+context.majorCollege+"},{国标专业个数："+context.internationalNum+"},{国标专业代码："
        +context.internationalCode+"},{专业代码："+context.majorCode+"},{专业名称："+context.majorName+"},{所属学科："+context.subject+"},{培养层次："
        +context.level+"},{学制："+context.length+"},{设置年份："+context.settingYear+"},{专业状态："+'启用'+"}]";
    context.json=json;
    if(context.checkStatus=='已通过'){
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
         `isDelete`,
         `updateMan`,
         `updateDate`,
         trainingobjects,
         introduction
         ) VALUES(UUID(),${majorCollege},${internationalNum},${internationalCode},${majorCode},
         ${majorName},${subject},${level},${length},${settingYear},"启用","启用","待审核",${majorId},"否",${sessionUserName},NOW(),${trainingobjects},${introduction})
         */},context);
        if(!result){
            rollback(con);
            closeconnection(con);
            return false;
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
         "启用",
         "待审核",
         ${json1},
         ${json}
         )
         */},context);
        if(!r){
            rollback(con);
            closeconnection(con);
            return false;
        }
    }else{
        var result = multiexec(con,function(){/*
         UPDATE
         `major`
         SET
         `majorStatus` = '启用'
         WHERE `majorId` =  ${majorId}
         */},context);
        if(!result){
            rollback(con);
            closeconnection(con);
            return false;
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
         "启用",
         "待审核",
         ${json1},
         ${json}
         )
         */},context);
        if(!r){
            rollback(con);
            closeconnection(con);
            return false;
        }
    }
    commit(con);
    closeconnection(con);
    return true;
}