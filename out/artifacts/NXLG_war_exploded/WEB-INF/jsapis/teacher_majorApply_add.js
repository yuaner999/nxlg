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
        context.level == null ||context.length == null ||context.settingYear == null || context.trainingobjects == null || context.introduction == null){
        return false;
    }
    var con = createconnection();
    var json="[{院(系)/部："+context.majorCollege+"},{国标专业个数："+context.internationalNum+"},{国标专业代码："
        +context.internationalCode+"},{专业代码："+context.majorCode+"},{专业名称："+context.majorName+"},{所属学科："+context.subject+"},{培养层次："
        +context.level+"},{学制："+context.length+"},{设置年份："+context.settingYear+"},{专业状态："+context.majorStatus+"},{培养对象："
        +context.trainingobjects+"},{专业简介："+context.introduction+"}]";
    context.json=json;
    context.majorId=uuid();
    //判断是否重复，院系、专业
    var valid=query(function(){/*
     SELECT * FROM `major` WHERE `majorCollege`=${majorCollege} and `majorName`=${majorName} and (isDelete IS NULL OR isDelete="否")
     */},context,"");
    if(valid.length>0){
        return 0;
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
         `createMan`,
         `createDate`,
          trainingobjects,
          introduction
     ) VALUES(${majorId},${majorCollege},${internationalNum},${internationalCode},${majorCode},
${majorName},${subject},${level},${length},${settingYear},"启用","待审核","新增",${sessionUserName},NOW(),${trainingobjects},${introduction})
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
     `after`
     )
     VALUES
     (
     UUID(),
     ${majorId},
     NOW(),
     "新增",
     "待审核",
     ${json}
     )
     */},context);
    if(!r){
        rollback(con);
        closeconnection(con);
        return false;
    }
    commit(con);
    closeconnection(con);
    return true;
}
var inputsamples=[{

}]