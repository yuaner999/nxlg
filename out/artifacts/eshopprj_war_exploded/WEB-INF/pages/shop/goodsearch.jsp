<%--
  Created by IntelliJ IDEA.
  User: liuzg
  Date: 2017/2/22
  Time: 14:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>商品搜索</title>
    <script>
        var pagecontextpath="${pageContext.request.contextPath}";
    </script>
    <%@include file="../commons/commonjs.jsp"%>
    <style>
        .subcategory {margin-left: 50px}
    </style>
</head>
<body ng-app="myApp" ng-controller="PageController">

    <div id="goodlist">
        <div class="gooditem" ng-repeat="gooditem in goodlist track by $index">
            <a href="gooddetail.form?goodid={{gooditem.goodid}}" ><span >{{gooditem.goodname}}</span></a>
            <span >{{gooditem.gooddesp}}</span>
        </div>
    </div>

    <div id="categories">
        <div class="categoryitem" ng-repeat="category in categories track by $index">
            <a href="goodsearch.form?cat={{catstr(category)}}"><span ng-bind="category.catename"></span></a>
            <div class="subcategories">
                <div class="subcategory" ng-repeat="subcategory in category.subcategories track by $index">
                    <a href="goodsearch.form?cat={{catstr(subcategory)}}"><span ng-bind="subcategory.catename"></span></a>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">

        function buildindex(category,parentcategory){
            if(category.parents==null) category.parents=[]
            if(parentcategory) category.parents.push(parentcategory.cateid)
            if(category.subcategories==null||category.subcategories.length==0) return;
            for(var i=0;i<category.subcategories.length;i++){
                var subcategory = category.subcategories[i];
                buildindex(subcategory,category)
            }
        }

        var app = angular.module('myApp', []);
        app.controller('PageController', function($scope) {
            scope = $scope;

            var good = {goodname:"a",gooddesp:"aaaa"};
//            $scope.goodlist=[
//                {goodname:"a",gooddesp:"aaaa"},
//                {goodname:"a2",gooddesp:"aaaa2"},
//                {goodname:"a3",gooddesp:"aaaa3"},
//            ]

            $scope.goodlist = remotecall("sp_goodsearch",{});
            $scope.categories = remotecall("sp_categories",{});
            $scope.catstr = function (category) {
                var cats = []
                for(var i in category.parents){
                    cats.push(category.parents[i]);
                }
                cats.push(category.cateid);
                return cats.join(",");
            }
            for(var i=0;i<$scope.categories.length;i++){
                var category = $scope.categories[i];
                buildindex(category,null);
            }
            console.log($scope.categories)
        });
    </script>
</body>
</html>
