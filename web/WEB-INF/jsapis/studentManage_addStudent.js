/**
 * Created by NEU on 2017/3/16.
 */
function main(context) {
    //基础数据非空判断
    if(context.studentNum == null||context.studentName == null||context.namePinYin == null||context.studentIDCard == null||context.studentGender == null){
        return false;
    }
    //新建学生信息并添加为用户
    var con=createconnection();
    var studentId=uuid();
    context.studentId=studentId;
    var result= multiexec(con,function () {/*
     INSERT INTO `student`(
     `studentId`,
     `studentNum`,
     `studentName`,
     `namePinYin`,
     `usedName`,
     `studentIcon`,
     `studentIDCard`,
     `studentGender`,
     `studentBirthday`,
     `studentNation`,
     `studentPolitics`,
     `studentPhone`,
     `studentEmail`,
     `linkMan`,
     `linkManPhone`,
     `linkManaddress`,
     `linkManPostcode`,
     `examNumber`,
     `province`,
     `highSchool`,
     `entranceDate`,
     `studentGrade`,
     `studentCollege`,
     `studentMajor`,
     `otherMajor`,
     `studentClass`,
     `studentLevel`,
     `studentLength`,
     `studentForm`,
     `studentSchoolAddress`,
     `isDelete`
     ) 
     VALUES
     (
     ${studentId},
     ${studentNum},
     ${studentName},
     ${namePinYin},
     ${usedName},
     ${studentIcon},
     ${studentIDCard},
     ${studentGender},
     ${studentBirthday},
     ${studentNation},
     ${studentPolitics},
     ${studentPhone},
     ${studentEmail},
     ${linkMan},
     ${linkManPhone},
     ${linkManaddress},
     ${linkManPostcode},
     ${examNumber},
     ${province},
     ${highSchool},
     ${entranceDate},
     ${studentGrade},
     ${studentCollege},
     ${studentMajor},
     ${otherMajor},
     ${studentClass},
     ${studentLevel},
     ${studentLength},
     ${studentForm},
     ${studentSchoolAddress},
     '否'
     )
*/},context);
    if(!result){
        rollback(con);
        closeconnection(con);
        return false;
    }else{
        result= multiexec(con,function () {/*
         INSERT INTO user
         (
         `userId`,
         `userName`,
         `password`,
         `userEmail`,
         `typeName`,
         `isNeuNb`,
         `typeId`,
         `roleId`,
         `userStatus`
         )
         VALUES
         (
         UUID(),
         ${studentNum},
         ENCODE('e10adc3949ba59abbe56e057f20f883e','371df050-00b3-11e7-829b-00ac2794c53f'),
         ${studentEmail},
         '学生',
         '否',
         ${studentId},
         'ebf0cc00-2335-11e7-a910-00ac9c2c0afa',
         '启用'
         )
         */},context,"");
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