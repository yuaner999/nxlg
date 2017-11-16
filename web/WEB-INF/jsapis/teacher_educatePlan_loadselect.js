/**
 * Created by NEU on 2017/3/18.
 */
function main(context) {
    //专业平台学分设置
    var r = query(function () {/*
     SELECT * FROM `educateplane` WHERE ep_grade=${ep_grade} AND ep_college=${ep_college} AND ep_major=${ep_major} AND ep_term=${ep_term} ep_courseid=${courseId};
     */}, context, "");
    return r;
}

    var inputsamples=[{
        terraceId:"1fd3def8-2415-11e7-be40-00ac9c2c0afa",
        majorId:"d795fafd-0e07-11e7-843d-00ac9c2c0afa"
    }]
