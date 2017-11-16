/**
 * Created by NEU-zcy on 2017/6/8.
 */
function main(context) {
    var result=query(function () {/*
     SELECT acId FROM arrangecourse WHERE is_now='1'   
   */},context,"");
    context.acId=result[0].acId;
    for(var i=0;i<context.deleteIds.length;i++){
        context.classroomId=context.deleteIds[i];
        var r=query(function () {/*
         SELECT al_Id FROM arrangelesson
         WHERE acId=${acId} AND classroomId=${classroomId}
         */},context,"");
        if(r!=""&&r!=null){
             return r;
        }
    }
    return r;
}

var inputsamples=[
    {
        deleteIds:["1a745b2f-4c1f-11e7-8629-d8cb8ab8c894"]
    }
]