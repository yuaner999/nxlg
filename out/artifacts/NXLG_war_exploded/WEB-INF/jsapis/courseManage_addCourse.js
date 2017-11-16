/**
 * Created by NEU on 2017/4/18.
 */
/*添加用户——步骤
1、判断负责教师是否是系统用户user，不是不能保存
2、发消息
3、保存，保存失败会撤回刚刚的消息*/
function main(context){
    //基础数据非空判断
    if(context.courseCode == null||context.chineseName == null||context.englishName == null||context.courseCategory_3 == null
        ||context.courseCategory_4 == null||context.courseCategory_5 == null||context.courseStatus == null){
        return false;
    }
    var con = createconnection();
    var json="[{课程代码："+context.courseCode+"},{中文名称："+context.chineseName+"},{英文名称：" +context.englishName+"},{承担单位："
        +context.assumeUnit+"},{课程类别三："+context.courseCategory_3+"},{课程类别四："+context.courseCategory_4+"},{课程类别五："
        +context.courseCategory_5+"},{总学分："+context.totalCredit+"},{理论学分："+context.theoreticalCredit+"},{实践学分："
        +context.practiceCredit+"},{讲授学时："+context.teachingTime+"},{实验学时："+context.experimentalTime+"},{上机学时："
        +context.machineTime+"},{其他学时："+context.otherTime+"},{总学时："+context.totalTime+"},{课程状态："+context.courseStatus+"}]";
    context.json=json;
    context.courseId=uuid();
    context.SMS=uuid();
    //判断是否重复,限制了课程名、承担单位。
    var valid=query(function(){/*
     SELECT * FROM `course` WHERE chineseName=${chineseName} and assumeUnit=${assumeUnit};
     */},context,"");
    console(valid);
    if(valid==null||valid.length==0){
        var a=query(function(){/*
         SELECT * FROM `user` WHERE typeId=${mainteacherid};
         */},context,"");
        if(a==null||a.length==0){
            return 0;   //该负责教师不是系统用户
        }else{
            context.id=a[0].userId;
            var b =multiexec(con,function(){/*
             INSERT INTO message (
             `messageId`,
             `messageTitle`,
             `messageContent`,
             `messageDate`,
             `isRead`,
             `receiverId`,
             `isDelete`
             )
             VALUES
             (
             ${SMS},
             "教学任务审核通知",
             "教学任务（教师开课）审核已通过",
             NOW(),
             "否",
             ${id},
             "否")
             */},context);
            if(!b){
                rollback(con);
                closeconnection(con);
                return 1;
            }
            var result=multiexec(con,function(){/*
             INSERT INTO `course` (
             `courseId`,
             `courseCode`,
             `chineseName`,
             `englishName`,
             `assumeUnit`,
             `courseCategory_3`,
             `courseCategory_4`,
             `courseCategory_5`,
             `totalCredit`,
             `totalTime`,
             `courseStatus`,
             `checkStatus`,
             `checkType`,`mainteacherid`
             )
             VALUES
             (
             uuid(),
             ${courseCode},
             ${chineseName},
             ${englishName},
             ${assumeUnit},
             ${courseCategory_3},
             ${courseCategory_4},
             ${courseCategory_5},
             ${totalCredit},
             ${totalTime},
             ${courseStatus},
             "待写教材",
             "新增",
             ${mainteacherid})
             */},context);
            if(!result){
                rollback(con);
                closeconnection(con);
                var b =exec(function(){/*
                 DELETE
                 FROM
                 `nxlg`.`message`
                 WHERE `messageId` = ${SMS};
                 */},context);
                return 9999;
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
             ${courseId},
             NOW(),
             "新增",
             "待写教材",
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
            return 2;
        }
    }else{ return 10;   }
    
}
