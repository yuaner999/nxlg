/**
 * Created by NEU on 2017/5/3.
 */
function main(context) {
    //sessionUserName非空判断
    if(getsession(context,"sessionUserName") == null){
        return false;
    }
    //基础数据非空判断
    if(context.ep_grade == null||context.ep_college == null||context.ep_major == null||context.ep_term == null
        ||context.courseId == null||context.courseCategory_1 == null||context.ep_terrace == null){
        return false;
    }
    var valid=query(function(){/*
     SELECT * FROM `educateplane` WHERE `ep_grade`=${ep_grade} and
     `ep_college`=${ep_college} and
     `ep_major`=${ep_major} and
     `ep_term`=${ep_term} and
      ep_courseid = ${courseId} and
     `courseCategory_1`=${courseCategory_1} and
     `ep_terrace`=${ep_terrace} and (ep_isDelete IS NULL OR ep_isDelete="否")
    */},context,"");
    if(valid.length>0){
        return 0;
    }else{
        /*限制一个课程只能属于本年级的某一个平台里。*/
        var gradeTerCourse=query(function(){/*
         SELECT ep_terrace FROM `educateplane` WHERE `ep_grade`=${ep_grade} and
         ep_courseid = ${courseId} and (ep_isDelete IS NULL OR ep_isDelete="否")
         */},context,"");
        console(context.ep_terrace);
        //console(gradeTerCourse[0].ep_terrace);
        if(gradeTerCourse.length>0&&gradeTerCourse[0].ep_terrace!=context.ep_terrace){
            console(gradeTerCourse[0].ep_terrace);
            return 1;
        }else{
            //培养计划设置
            var rr = exec(function () {/*
             INSERT INTO `educateplane` (
             `ep_id`,
             `ep_grade`,
             `ep_college`,
             `ep_major`,
             `ep_term`,
             `ep_courseid`,
             `courseCategory_1`,
             `ep_terrace`,
             `ep_checkway`,
             `ep_week`,
             `ep_note`,
             `ep_checkStatus`,
             `ep_checkType`,
             `ep_setman`,
             `ep_settime`
             )
             VALUES
             (
             UUID(),
             ${ep_grade},
             ${ep_college},
             ${ep_major},
             ${ep_term},
             ${courseId},
             ${courseCategory_1},
             ${ep_terrace},
             ${ep_checkway},
             ${ep_week},
             ${ep_note},
             "待审核",
             "新增",
             ${sessionUserName},
             NOW()
             ) ;
             */}, context);
            return rr;
        }
    }
}
