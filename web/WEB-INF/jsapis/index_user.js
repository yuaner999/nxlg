/**
 * Created by NEU on 2017/4/12.
 */
function main(context) {
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
        var type = rr[0].typeName;
        if(type=="学生"){
            return {result:rr[0].studentName};
        }else if(type=="教师"){
            return {result:rr[0].teacherName};
        }else if(type=="管理员"){
            return {result:rr[0].adminName};
        }else{
            return {result:type};
        }
    }else{
        return {result:false};
    }
}
