/**
 * Created by NEU on 2017/3/18.
 */
function main(context) {
    //专业平台学分设置
    var data=[];
    var r = query(function () {/*
     SELECT `terraceId`,`terraceName` FROM `terrace`
     */}, context, "");
    if(r.length>0||r!=null){
        for(var i=0;i<r.length;i++){
            context.terraceId=r[i].terraceId;
            var rr = query(function () {/*
             SELECT * FROM `majorterracescore` WHERE terraceId=${terraceId} AND majorId=${majorId};
             */}, context, "");
            console(rr);
            if(rr.length<1||rr==null) {
                var rrr={terraceName:r[i].terraceName,terraceId:r[i].terraceId};
                data.push(rrr);
            }else{
                rr[0].terraceName=r[i].terraceName;
                data.push(rr[0]);
            }
            console("zhangyuan:"+data);
        }
        return data;
    }else{return false;}
}

    var inputsamples=[{
        majorId:"d795fafd-0e07-11e7-843d-00ac9c2c0afa"
    }]
