/**
 * Created by NEU on 2017/4/18.
 */
function main(context){
    //基础数据非空判断
    if(context.courseId == null||context.coursebookid == null){
        return false;
    }
    var result=exec(function(){/*
     UPDATE
     `course`
     SET
     `checkStatus`="待审核",
     `coursebookid`=${coursebookid},
     `sparecoursebookid`=${coursebook},
     `issparecourse`='0'
     WHERE `courseId` = ${courseId}
     */},context);
    return result;
}

var inputsamples=[
    {
    }
]