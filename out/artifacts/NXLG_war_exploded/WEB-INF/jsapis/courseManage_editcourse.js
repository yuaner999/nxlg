/**
 * Created by NEU on 2017/4/18.
 */
/*修改用户—— */
function main(context){
    //基础数据非空判断
    if(context.courseCode == null||context.chineseName == null||context.englishName == null||context.assumeUnit == null||context.courseCategory_3 == null
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
    context.SMS=uuid();
   // console(context.changebook);
    //判断是否重复,限制了课程名、承担单位。
    var n=query(function () {/*
     SELECT * FROM `course` WHERE  relationId=${courseId} AND checkStatus="待审核"
     */},context,"");
    if(n.length>0){
        rollback(con);
        closeconnection(con);
        return 11;
    }
    var valid=query(function(){/*
     SELECT * FROM `course` WHERE chineseName=${chineseName} and assumeUnit=${assumeUnit} and courseId<>${courseId} and relationId <> ${courseId}
     */},context,"");
    //console(valid);
   // console(valid==null||valid.length==0);
    if(valid==null||valid.length==0){
        if (context.checkStatus=='已通过'){//对于已通过的数据，修改时先新建一条数据，再次审核通过后删除原数据
            var e=query(function () {/*
             select * from course where (checkStatus="待审核" or checkStatus="待写教材") and (courseCode=${courseCode} or relationId=${courseId})
             */},context,"");
          //  console(e.length);
            if(e.length>0){
                rollback(con);
                closeconnection(con);
                return 9;
            }
            if(context.changebook=="是") {//发送消息，更改教材
                var a=query(function(){/*
                 SELECT * FROM `user` WHERE typeId=${mainteacherid};
                 */},context,"");
                if(a==null||a.length==0){
                    rollback(con);
                    closeconnection(con);
                    return 0;   //该负责教师不是系统用户
                }else{
                    context.id=a[0].userId;//发消息
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
                     `theoreticalCredit`,
                     `practiceCredit`,
                     `teachingTime`,
                     `experimentalTime`,
                     `machineTime`,
                     `otherTime`,
                     `totalTime`,
                     `courseStatus`,
                     `checkStatus`,
                     `checkType`,
                     `relationId`,`mainteacherid`
                     )
                     VALUES
                     (
                     UUID(),
                     ${courseCode},
                     ${chineseName},
                     ${englishName},
                     ${assumeUnit},
                     ${courseCategory_3},
                     ${courseCategory_4},
                     ${courseCategory_5},
                     ${totalCredit},
                     ${theoreticalCredit},
                     ${practiceCredit},
                     ${teachingTime},
                     ${experimentalTime},
                     ${machineTime},
                     ${otherTime},
                     ${totalTime},
                     ${courseStatus},
                     '待写教材',
                     '修改',
                     ${courseId},
                     ${mainteacherid}
                     )
                     */},context,"");
                    if(!result){
                        rollback(con);
                        closeconnection(con);
                        //如果添加数据失败，撤回发送的消息
                        var b =exec(function(){/*
                         DELETE
                         FROM
                         `nxlg`.`message`
                         WHERE `messageId` = ${SMS};
                         */},context);
                        return 2;
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
                     ${courseId},
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
                return 4;
            }else{
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
                 `theoreticalCredit`,
                 `practiceCredit`,
                 `teachingTime`,
                 `experimentalTime`,
                 `machineTime`,
                 `otherTime`,
                 `totalTime`,
                 `courseStatus`,
                 `checkStatus`,
                 `checkType`,
                 `relationId`,`mainteacherid`,`coursebookid`
                 )
                 VALUES
                 (
                 UUID(),
                 ${courseCode},
                 ${chineseName},
                 ${englishName},
                 ${assumeUnit},
                 ${courseCategory_3},
                 ${courseCategory_4},
                 ${courseCategory_5},
                 ${totalCredit},
                 ${theoreticalCredit},
                 ${practiceCredit},
                 ${teachingTime},
                 ${experimentalTime},
                 ${machineTime},
                 ${otherTime},
                 ${totalTime},
                 ${courseStatus},
                 '待审核',
                 '修改',
                 ${courseId},
                 ${mainteacherid},
                 ${coursebookid}
                 )
                 */},context,"");
                if(!result){
                    rollback(con);
                    closeconnection(con);
                    return 5;
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
                 ${courseId},
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
                    return 6;
                }
            }
            commit(con);
            closeconnection(con);
            return 7;
        }else {//待审核、未通过、待写教材
            if(context.changebook=="是"){//发送消息，更改教材
                var a=query(function(){/*
                 SELECT * FROM `user` WHERE typeId=${mainteacherid};
                 */},context,"");
                if(a==null||a.length==0){
                    rollback(con);
                    closeconnection(con);
                    return 0;   //该负责教师不是系统用户
                }else{
                    context.id=a[0].userId;//给负责教师（用户）发消息
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
                        return 1;//消息发送失败
                    }
                    var result=multiexec(con,function(){/*
                     UPDATE
                     `course`
                     SET
                     `courseCode` = ${courseCode},
                     `chineseName` = ${chineseName},
                     `englishName` = ${englishName},
                     `assumeUnit` = ${assumeUnit},
                     `courseCategory_3` = ${courseCategory_3},
                     `courseCategory_4` = ${courseCategory_4},
                     `courseCategory_5` = ${courseCategory_5},
                     `totalCredit` = ${totalCredit},
                     `theoreticalCredit` = ${theoreticalCredit},
                     `practiceCredit` = ${practiceCredit},
                     `teachingTime` = ${teachingTime},
                     `experimentalTime` = ${experimentalTime},
                     `machineTime` = ${machineTime},
                     `otherTime` = ${otherTime},
                     `totalTime` = ${totalTime},
                     `courseStatus` = ${courseStatus},
                     `refuseReason` = '',
                     `checkStatus` = '待写教材',
                     `checkType`='修改',
                     `mainteacherid`=${mainteacherid}
                     WHERE `courseId` = ${courseId}
                     */},context);
                    if(!result){
                        rollback(con);
                        closeconnection(con);
                        //如果添加数据失败，撤回发送的消息
                        var b =exec(function(){/*
                         DELETE
                         FROM
                         `nxlg`.`message`
                         WHERE `messageId` = ${SMS};
                         */},context);
                        return 2;
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
                     ${courseId},
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
                return 4;//
            }else{
                var result=multiexec(con,function(){/*
                 UPDATE
                 `course`
                 SET
                 `courseCode` = ${courseCode},
                 `chineseName` = ${chineseName},
                 `englishName` = ${englishName},
                 `assumeUnit` = ${assumeUnit},
                 `courseCategory_3` = ${courseCategory_3},
                 `courseCategory_4` = ${courseCategory_4},
                 `courseCategory_5` = ${courseCategory_5},
                 `totalCredit` = ${totalCredit},
                 `theoreticalCredit` = ${theoreticalCredit},
                 `practiceCredit` = ${practiceCredit},
                 `teachingTime` = ${teachingTime},
                 `experimentalTime` = ${experimentalTime},
                 `machineTime` = ${machineTime},
                 `otherTime` = ${otherTime},
                 `totalTime` = ${totalTime},
                 `courseStatus` = ${courseStatus},
                 `refuseReason` = '',
                 `checkStatus` = '待审核',
                 `checkType`='修改',
                 `mainteacherid`=${mainteacherid}
                 WHERE `courseId` = ${courseId}
                 */},context);
                if(!result){
                    rollback(con);
                    closeconnection(con);
                    return 5;
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
                 ${courseId},
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
                    return 6;
                }
            }
            commit(con);
            closeconnection(con);
            return 7;
        }
    }else{return  10;}
}