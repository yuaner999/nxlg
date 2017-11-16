/**
 * Created by NEU on 2017/4/12.
 */
function main(context) {
    console(context.sessionUserID);
    var rr = query(function () {/*
     SELECT * FROM
     `nxlg`.`user`
     LEFT JOIN `nxlg`.`student`
     ON (`user`.`typeId` = `student`.`studentId`)
     LEFT JOIN `nxlg`.`teacher`
     ON (`user`.`typeId` = `teacher`.`teacherId`)
     LEFT JOIN `nxlg`.`admin`
     ON (`user`.`typeId` = `admin`.`adminId`)
     WHERE userId=${sessionUserID}
     */},context,"");
    if(rr){
        if(rr[0].typeName=="学生"){
            return {result:rr[0],UCphone:rr[0].studentPhone,UCemail:rr[0].studentEmail,UCimage:rr[0].studentIcon};
        }else if(rr[0].typeName=="教师"){
            return {result:rr[0],UCphone:rr[0].phone,UCemail:rr[0].email,UCimage:rr[0].teacherIcon};
        }else if(rr[0].typeName=="管理员"){
            return {result:rr[0],UCphone:rr[0].adminPhone,UCemail:rr[0].adminEmail,UCimage:rr[0].adminIcon};
        }else{
            return {result:false,errormessage:"管理员未给该用户分配用户类型"};
        }
    }else{
        return {result:false,errormessage:"无该用户信息"};
    }
}
