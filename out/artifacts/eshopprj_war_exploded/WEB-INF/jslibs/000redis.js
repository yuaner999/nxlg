/**
 * Created by liuzg on 2016/12/24.
 */
//从redis中获取值
function redisgetvalue(key) {
    return redis.get(key);
}
//设置redis的值
function redissetvalue(key, value,expire) {
    redis.set(key,value,expire)
}
//判断redis中是否包含值
function rediscontainKey(key) {
    return redis.containKey(key);
}