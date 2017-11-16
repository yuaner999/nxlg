/**
 * Created by NEU on 2017/3/18.
 */
function main(context) {
    //数据非空判断
    if(context.teacherNumber == null||context.teacherName == null||context.teacherGender == null||context.nation == null||context.politics == null
        ||context.politicsDate == null||context.IDCard == null||context.birthday == null||context.schoolDate == null||context.department == null
        ||context.phone == null||context.degree == null||context.teachUnit == null){
        return false;
    }
    //新建教师信息并添加为用户
    var con=createconnection();
    var teacherId=uuid();
    context.teacherId=teacherId;
    if(context.employDate=="") context.employDate=null;
    var result = multiexec(con,function () {/*
     INSERT INTO `teacher` (
     `teacherId`,
     `teacherNumber`,
     `teacherName`,
     `teacherIcon`,
     `teacherGender`,
     `nation`,
     `politics`,
     `politicsDate`,
     `IDCard`,
     `birthday`,
     `schoolDate`,
     `department`,
     `administrative`,
     `teachUnit`,
     `duty`,
     `dutyDate`,
     `dutyLevel`,
     `education`,
     `educationDate`,
     `educationMajor`,
     `educationSchool`,
     `educationStructure`,
     `degree`,
     `degreeDate`,
     `degreeMajor`,
     `degreeSchool`,
     `certificate`,
     `certificateDate`,
     `teachDate`,
     `teachMajor`,
     `teachSection`,
     `teachStatus`,
     `teachArea`,
     `isCompile`,
     `contract`,
     `fiveOne`,
     `teachCollege`,
     `doubleTeacher`,
     `certificateLevel`,
     `bBackground`,
     `pBackground`,
     `employ`,
     `employUnit`,
     `employDate`,
     `employSource`,
     `native`,
     `address`,
     `phone`,
     `email`,
     `onGuard`,
     `status`,
     `isDelete`
     )
     VALUES
     (
     ${teacherId},
     ${teacherNumber},
     ${teacherName},
     ${teacherIcon},
     ${teacherGender},
     ${nation},
     ${politics},
     ${politicsDate},
     ${IDCard},
     ${birthday},
     ${schoolDate},
     ${department},
     ${administrative},
     ${teachUnit},
     ${duty},
     ${dutyDate},
     ${dutyLevel},
     ${education},
     ${educationDate},
     ${educationMajor},
     ${educationSchool},
     ${educationStructure},
     ${degree},
     ${degreeDate},
     ${degreeMajor},
     ${degreeSchool},
     ${certificate},
     ${certificateDate},
     ${teachDate},
     ${teachMajor},
     ${teachSection},
     ${teachStatus},
     ${teachArea},
     ${isCompile},
     ${contract},
     ${fiveOne},
     ${teachCollege},
     ${doubleTeacher},
     ${certificateLevel},
     ${bBackground},
     ${pBackground},
     ${employ},
     ${employUnit},
     ${employDate},
     ${employSource},
     ${native},
     ${address},
     ${phone},
     ${email},
     ${onGuard},
     ${status},
     '否'
     )
     */},context,"");
    if(!result){
        rollback(con);
        closeconnection(con);
        return false;
    }else{
        console(context)
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
         ${teacherNumber},
         ENCODE('e10adc3949ba59abbe56e057f20f883e','371df050-00b3-11e7-829b-00ac2794c53f'),
         ${email},
         '教师',
         '否',
         ${teacherId},
         'c8a698e9-3ad4-11e7-9360-00ac9c2c0afa',
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