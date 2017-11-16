/**
 * Created by NEU on 2017/4/18.
 */
function main(context){
    var con = createconnection();
    var json="[{课程代码："+context.courseCode+"},{中文名称："+context.chineseName+"},{英文名称：" +context.englishName+"},{承担单位："
        +context.assumeUnit+"},{课程类别三："+context.courseCategory_3+"},{课程类别四："+context.courseCategory_4+"},{课程类别五："
        +context.courseCategory_5+"},{总学分："+context.totalCredit+"},{理论学分："+context.theoreticalCredit+"},{实践学分："
        +context.practiceCredit+"},{讲授学时："+context.teachingTime+"},{实验学时："+context.experimentalTime+"},{上机学时："
        +context.machineTime+"},{其他学时："+context.otherTime+"},{总学时："+context.totalTime+"},{课程状态："+context.courseStatus+"}]";
    context.json=json;
    if (context.checkStatus=='已通过'){
        var r=query(function () {/*
         select * from course where (checkStatus="待审核" or checkStatus="待写教材") and (courseCode=${courseCode} or relationId=${courseId})
        */},context,"");
        if(r.length>0){
            return 2;
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
         '待审核',
         '删除',
         ${courseId},
         ${mainteacherid}
         )
         */},context,"");
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
         `before`
         )
         VALUES
         (
         UUID(),
         ${courseId},
         NOW(),
         "删除",
         "待审核",
         ${json}
         )
         */},context);
        if(!r){
            rollback(con);
            closeconnection(con);
            return false;
        }
    }else {
        var result=multiexec(con,"delete from course where courseId=${courseId}",context);
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
         `before`
         )
         VALUES
         (
         UUID(),
         ${courseId},
         NOW(),
         "删除",
         "待审核",
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
var inputsamples=[
    {
        checkType:"新增",
        englishName:"",
        totalCredit:"1",
        courseCode:"1",
        courseCategory_5:"自然科学类",
        courseCategory_4:"普通课",
        courseCategory_3:"课程课",
        teachingTime:"1",
        checkStatus:"已通过",
        experimentalTime:"1",
        chineseName:"1",
        courseStatus:"启用",
        courseId:"053b86ec-d3f0-435d-8c42-11af820dbefe"
    }
]