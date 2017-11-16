/**
 * Created by NEU on 2017/7/4.
 */
function main(context) {
    //加载专业
    var re = query(function () {/*
     SELECT majorCollege,majorId,`majorName` FROM `major`
      where majorCollege in (select distinct(wordbookValue) as majorCollegeValue from wordbook where wordbookKey='学院')
     AND  (`major`.`checkStatus` = '已通过') AND (ISNULL(`major`.`isDelete`) OR (`major`.`isDelete` = '否'))
     */},context,"majorCollege,majors:[majorId,majorName]");
    return re;
}

var inputsamples=[{}]