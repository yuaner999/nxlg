/**
 * Created by NEU on 2017/3/18.
 */
function main(context){
    //删除
    var con = createconnection();
    var json="[{院(系)/部："+context.majorCollege+"},{国标专业个数："+context.internationalNum+"},{国标专业代码："
        +context.internationalCode+"},{专业代码："+context.majorCode+"},{专业名称："+context.majorName+"},{所属学科："+context.subject+"},{培养层次："
        +context.level+"},{学制："+context.length+"},{设置年份："+context.settingYear+"},{专业状态："+context.majorStatus+"}]";
    context.json=json;
    if(context.checkStatus=='已通过'){
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
         `checkType`,
         `checkStatus`,
         `relationId`,
         `updateMan`,
         `updateDate`
         ) VALUES(UUID(),${majorCollege},${internationalNum},${internationalCode},${majorCode},
         ${majorName},${subject},${level},${length},${settingYear},${majorStatus},"删除","待审核",${majorId},${sessionUserName},NOW())
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
         */},context);
        if(!r){
            rollback(con);
            closeconnection(con);
            return 3;
        }
    }else{
        var result = multiexec(con,"delete from major where majorId=${majorId}",context);
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