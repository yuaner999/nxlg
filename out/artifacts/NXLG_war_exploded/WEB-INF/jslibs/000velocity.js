/**
 * Created by Administrator on 2017/1/1.
 */
function velocitytemplate(templatestr, params) {
    var template = sql(templatestr);
    return velocity.velocitytemplate(template,params);
}