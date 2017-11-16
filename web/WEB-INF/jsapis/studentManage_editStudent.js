/**
 * Created by NEU on 2017/3/16.
 */
function main(context) {
    //基础数据非空判断
    if(context.studentNum == null||context.studentName == null||context.studentId == null||context.studentIDCard == null||context.studentGender == null){
        return false;
    }
    //修改学生、用户信息
    var con=createconnection();
    var result = multiexec(con,function () {/*
     UPDATE
     `student`
     SET
     `studentNum` = ${studentNum},
     `studentName` = ${studentName},
     `namePinYin` = ${namePinYin},
     `usedName` = ${usedName},
     `studentIcon` = ${studentIcon},
     `studentIDCard` = ${studentIDCard},
     `studentGender` = ${studentGender},
     `studentBirthday` = ${studentBirthday},
     `studentNation` = ${studentNation},
     `studentPolitics` = ${studentPolitics},
     `studentPhone` = ${studentPhone},
     `studentEmail` = ${studentEmail},
     `linkMan` = ${linkMan},
     `linkManPhone` = ${linkManPhone},
     `linkManaddress` = ${linkManaddress},
     `linkManPostcode` = ${linkManPostcode},
     `examNumber` = ${examNumber},
     `province` = ${province},
     `highSchool` = ${highSchool},
     `entranceDate` = ${entranceDate},
     `studentGrade` = ${studentGrade},
     `studentCollege` = ${studentCollege},
     `studentMajor` = ${studentMajor},
     `otherMajor` = ${otherMajor},
     `studentClass` = ${studentClass},
     `studentLevel` = ${studentLevel},
     `studentLength` = ${studentLength},
     `studentForm` = ${studentForm},
     `studentSchoolAddress` = ${studentSchoolAddress},
     `isDelete` = '否'
     WHERE `studentId` = ${studentId}
     */},context);
    if(!result){
        rollback(con);
        closeconnection(con);
        return false;
    }else{
        var result = multiexec(con,function () {/*
         UPDATE `user`
         SET
         `userName` = ${studentNum},
         `userEmail`=${studentEmail},
         `typeName` = '学生',
         `roleId` = 'ebf0cc00-2335-11e7-a910-00ac9c2c0afa'
         WHERE `typeId` = ${studentId}
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