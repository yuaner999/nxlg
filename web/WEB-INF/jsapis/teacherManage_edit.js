/**
 * Created by NEU on 2017/3/18.
 */
function main(context) {
    //数据非空判断
    if(context.teacherNumber == null||context.teacherName == null||context.teacherId == null||context.nation == null||context.politics == null
        ||context.politicsDate == null||context.IDCard == null||context.birthday == null||context.schoolDate == null||context.department == null
        ||context.phone == null||context.degree == null||context.teachUnit == null){
        return false;
    }
    // 修改教师、用户信息
    var con=createconnection();
    if(context.employDate=="") context.employDate=null;
    var result = multiexec(con,function () {/*
     UPDATE
     `teacher`
     SET
     `teacherNumber` = ${teacherNumber},
     `teacherName` = ${teacherName},
     `teacherIcon` = ${teacherIcon},
     `teacherGender` = ${teacherGender},
     `nation` = ${nation},
     `politics` = ${politics},
     `politicsDate` = ${politicsDate},
     `IDCard` = ${IDCard},
     `birthday` = ${birthday},
     `schoolDate` = ${schoolDate},
     `department` = ${department},
     `administrative` = ${administrative},
     `teachUnit` = ${teachUnit},
     `duty` = ${duty},
     `dutyDate` = ${dutyDate},
     `dutyLevel` = ${dutyLevel},
     `education` = ${education},
     `educationDate` = ${educationDate},
     `educationMajor` = ${educationMajor},
     `educationSchool` = ${educationSchool},
     `educationStructure` = ${educationStructure},
     `degree` = ${degree},
     `degreeDate` = ${degreeDate},
     `degreeMajor` = ${degreeMajor},
     `degreeSchool` = ${degreeSchool},
     `certificate` = ${certificate},
     `certificateDate` = ${certificateDate},
     `teachDate` = ${teachDate},
     `teachMajor` = ${teachMajor},
     `teachSection` = ${teachSection},
     `teachStatus` = ${teachStatus},
     `teachArea` = ${teachArea},
     `isCompile` = ${isCompile},
     `contract` = ${contract},
     `fiveOne` = ${fiveOne},
     `teachCollege` = ${teachCollege},
     `doubleTeacher` = ${doubleTeacher},
     `certificateLevel` = ${certificateLevel},
     `bBackground` = ${bBackground},
     `pBackground` = ${pBackground},
     `employ` = ${employ},
     `employUnit` = ${employUnit},
     `employDate` = ${employDate},
     `employSource` = ${employSource},
     `native` = ${native},
     `address` = ${address},
     `phone` = ${phone},
     `email` = ${email},
     `onGuard` = ${onGuard},
     `status` = ${status},
     `isDelete` = '否'
     WHERE `teacherId` = ${teacherId}
     */},context,'');
    if(!result){
        rollback(con);
        closeconnection(con);
        return false;
    }else{
        var result = multiexec(con,function () {/*
         UPDATE `user`
         SET
         `userName` = ${teacherNumber},
         `userEmail` = ${email},
         `typeName` = '教师'
         WHERE `typeId` = ${teacherId}
         */},context);
        if(!result){
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
        
    }
]
