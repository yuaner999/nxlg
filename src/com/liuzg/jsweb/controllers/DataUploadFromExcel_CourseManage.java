package com.liuzg.jsweb.controllers;

import com.Services.interfaces.CourseManageService;
import com.model.ResultData;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.InputStream;
import java.text.ParseException;
import java.util.*;

import static com.utils.ExcelUtil.getCellStringValue;

/**
 * 上传excel文件，批量导入课程信息的controller
 * Created by zqy on 2017/10/11.
 */

@Controller
@RequestMapping("/CourseManage")
@Scope("prototype")
public class DataUploadFromExcel_CourseManage {
        @Autowired
        private CourseManageService courseManageService;
        //文件最大值
        //private long maxSize = 10*1024*1024;
        //表格的名字，区分是哪些数据
        private String tableName="";
        //数据总行数
        private int totalrows=0;
        //成功保存的数据行数
        private int saveRows=0;
        //批量保存数据库的批次
        private final int batch=2000;
        /**
         * 上传课程信息表
         * @param request
         * @param response
         * @return
         */
        @RequestMapping("/CourseManage_upload")
        @ResponseBody
        public ResultData exec(HttpServletRequest request, HttpServletResponse response) {
            long start=System.currentTimeMillis();
            ResultData resultData;
            response.reset();
            response.setCharacterEncoding("UTF-8");
            response.setContentType("text/html");
            //从请求中加载文件
            resultData=getFileFromRequest(request);
            if(resultData.getStatus()!=0)return resultData;
            FileItem item= (FileItem) resultData.getData();
            List<Map<String ,String >> list= null;
            try {
                //交给excel处理程序 将表格中的数据转换成map的集合，每个map就是一行记录
                list=excelProcess(item.getInputStream());
                //验证excel文件中数据的完整及唯一性
                List<ResultData> resultlist=uqValid(list);
                if(resultlist.size()>0){
                    resultData.sets(1,"文件中有错误");
                    resultData.setData(resultlist);
                    return resultData;
                }
                //获取老师的所在学院
                Map<String,String> map = new HashMap<>();
                String sessionUserName = (String) request.getSession().getAttribute("sessionUserName");
                map.put("sessionUserName",sessionUserName);
                if(tableName!=null && tableName.contains("courseManage")){
                   List<Map<String,String>> teacherCollegelist = courseManageService.getTeacherCollege(map);
                   if(teacherCollegelist.size() > 0){
                       for (int i = 0; i < list.size(); i++){
                           list.get(i).put("assumeUnit",teacherCollegelist.get(0).get("teachCollege"));
                       }
                   }
                }
                //验证数据是否和数据库中的数据是否有重复
                if(tableName!=null && tableName.contains("courseManage")){
                    resultData=primaryKeyValid(list);
                    if(resultData.getStatus()!=0)
                        return resultData;
                }
                //把转换完成的数据交给数据存储处理函数
                List<String > error_list=saveCourseManage(list);
                resultData.setData(error_list);
                //添加消息通知
                int Message =courseManageService.saveMessage(map);
                if(Message == 0){
                    resultData.setMsg("添加消息通知失败");
                    return resultData;
                }
            } catch (IOException e) {
                e.printStackTrace();
                resultData.sets(-1, e.getMessage());
                return resultData;
            }catch (ParseException e){
                e.printStackTrace();
                resultData.sets(-1, e.getMessage());
                return resultData;
            }
            long times=System.currentTimeMillis()-start;
            resultData.setMsg("共计"+totalrows+"行数据，成功保存"+saveRows+"行，用时："+times+"ms");
            saveRows=0;
            return resultData;
        }

        /**
         * 验证上传文件的数据合不合格(主要是重复性检测)
         * @param request
         * @param response
         * @return
         */
        @RequestMapping("/validate")
        @ResponseBody
        public ResultData validUploadFile(HttpServletRequest request, HttpServletResponse response){
            long start=System.currentTimeMillis();    //执行所用时间
            ResultData resultData ;
            response.reset(); //清除首部空白行
            response.setCharacterEncoding("UTF-8"); //设置从request中取得的值或从数据库中取出的值
            response.setContentType("text/html");
            resultData=getFileFromRequest(request);   //检验文件是否上传以及格式是否正确
            if(resultData.getStatus()!=0) return resultData;
            FileItem item= (FileItem) resultData.getData();
            //取出文件后把data清空，否则有可能会被返回给客户端，从而导致报错
            resultData.setData(null);
            //交给excel处理程序 将表格中的数据转换成map的集合，每个map就是一行记录
            List<Map<String ,String >> list= null;
            try {
                list = excelProcess(item.getInputStream());
            } catch (IOException e) {
                e.printStackTrace();
                resultData.sets(-1,e.getMessage().substring(2001));
                return resultData;
            }
            //验证excel文件中数据的完整及唯一性
            List<ResultData> resultlist=uqValid(list);
            if(resultlist.size()>0){
                resultData.sets(1,"文件中有错误");
                resultData.setData(resultlist);
                return resultData;
            }
            //验证是否存在数据是否重复
            if(tableName!=null && tableName.contains("courseManage")){
                resultData=primaryKeyValid(list);
                if(resultData.getStatus()!=0)
                    return resultData;
            }
            long times=System.currentTimeMillis()-start;
            resultData.setMsg("文件检测完成，共计"+totalrows+"行数据，用时："+times+"ms");
            return resultData;
        }

        /**
         * 从request中加载文件
         * @param request
         * @return
         */
        public ResultData getFileFromRequest(HttpServletRequest request) {
            ResultData resultData=new ResultData();
            //检查是否上传了文件
            if (!ServletFileUpload.isMultipartContent(request)) {
                resultData.sets(1, "请选择文件");
                return resultData;
            }
            //获取文件
            FileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);
            List items = null;
            try {
                items = upload.parseRequest(request);
//            System.out.println(items.size());
            } catch (FileUploadException e) {
                e.printStackTrace();
                resultData.sets(-1, e.getMessage());
                return resultData;
            }
            Iterator itr = items.iterator();
            FileItem item=null;
            if(itr.hasNext()) {
                item = (FileItem) itr.next();
                String fileName = item.getName();
                if (!item.isFormField()) {
                    tableName=fileName.substring(0,fileName.lastIndexOf("."));
                    // 检查扩展名
                    String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
                    if (!"xls".equals(fileExt)) {
                        resultData.sets(1, "上传文件格式不正确！");
                        return resultData;
                    }
//                System.out.println("上传文件检查文件完成");
                }
            }
            resultData.setData(item);
            return resultData;
        }

        /**
         * 把数据保存到数据库
         * @param list
         * @return 错误的信息
         * @throws ParseException
         */
        private List<String> saveCourseManage(List<Map<String ,String >> list) throws ParseException {
            //缴费信息列表
            //List<EducatePlan> EducatePlans=new ArrayList<>();
            //错误信息存放集合
            List<String > errorList=new ArrayList<>();
            int i=0;
            List<String> TeachingMaterial =courseManageService.getCourseCode(list);
            if(TeachingMaterial.size()>0){
                errorList.add("课程信息已存在，请仔细核对");
            }
            System.out.println("1"+TeachingMaterial);
            for(Map<String ,String > map:list){
                map.put("isdelete","0");
                i++;
                if(i%batch==0){
                    try{
                        int result=0;
                        //根据文件名字的不同，调用不同的service
                        if(tableName.contains("courseManage")){
                            result= courseManageService.saveCourseManage(list);
                        }
                        if(result<=0){
                            errorList.add("第"+(i-batch<=0?1:i-batch+1)+"行至第"+i+"行保存至数据库失败，原因：加载数据库失败");
                        }else{
                            saveRows+=result;
                        }
                    }catch (Exception e){
                        e.getStackTrace();
                        String msg=e.getMessage();
                        errorList.add("第"+(i-batch<=0?1:i-batch+1)+"行至第"+i+"行保存至数据库失败，原因："+e.getMessage().substring(0,msg.length()>2000?2000:msg.length()));
//                    System.out.println("第"+(i-batch<=0?1:i-batch+1)+"行至第"+i+"行保存至数据库失败，原因："+e.getMessage().substring(0,msg.length()>2000?2000:msg.length()));
                    }
                    list.clear();
                }
            }
            try{
                int result=0;
                //根据文件名字的不同，调用不同的service
                if(tableName.contains("courseManage")){
                    //System.out.println("EducatePlans.size:"+list.size());
                    result=courseManageService.saveCourseManage(list);
                }
//            System.out.println(result);
                if(result<=0){
                    errorList.add("第"+((i/batch)*batch+1)+"行至第"+i+"行保存至数据库失败，原因：加载数据库失败");
                }else{
                    saveRows+=result;
                }
            }catch (Exception e){
                e.printStackTrace();
                String msg=e.getMessage();
                errorList.add("第"+((i/batch)*batch+1)+"行至第"+i+"行保存至数据库失败，原因："+msg.substring(0,msg.length()>2000?2000:msg.length()));
//            System.out.println("第"+((i/batch)*batch+1)+"行至第"+i+"行保存至数据库失败，原因："+e.getMessage().substring(0,msg.length()>2000?2000:msg.length()));
            }
//        System.out.println(errorList.size());
            return errorList;
        }

        /**
         * 处理excel中的数据，返回Map的集合。每个map 就是一行数据
         * @param input
         * @return
         * @throws IOException
         */
        private List<Map<String ,String >> excelProcess(InputStream input) throws IOException{
            List<Map<String ,String >> list=new ArrayList<>();
            HSSFWorkbook hssfWorkbook = new HSSFWorkbook(input);   //创建一个新的excel
            HSSFSheet sheet=hssfWorkbook.getSheetAt(0);    //获取excel中表格
            List<String > fieldName=new ArrayList<>();
            //总数据行数 ，表格的总行数，减去前三行标题
//        String tabname=sheet.getRow(0).getCell(0).getStringCellValue();
//        if(tabname!=null && !tabname.equals("")){
//            tableName=tabname.split("#")[0];
//        }
            totalrows=sheet.getLastRowNum()-3+1;   //获取总行数-前3行
            for(int i=1;i<=sheet.getLastRowNum();i++){//行循环
                //跳过第三行 （中文标题）
                if(i==2)continue;
                HSSFRow row=sheet.getRow(i); //获取第i行数据
                Map<String ,String> map=new HashMap<>();
                for(int j=0;j<=row.getLastCellNum();j++){//列循环
                    HSSFCell cell=row.getCell(j);
                    if(cell==null)continue;
                    String cellvalue=getCellStringValue(cell);
                    if(cellvalue!=null && !cellvalue.equals("")){
                        cellvalue=cellvalue.trim().replaceAll("[\n\t\r]*","");
                    }
                    //如果是第二行（字段名）则放到另一个list中
                    if(i==1) {
                        fieldName.add(cellvalue);
                    }else{
                        map.put(fieldName.get(j),cellvalue);
                    }
                }
                if(i!=1) list.add(map);
            }
            return list;
        }

        /**
         * excel中数据的非空验证
         * @param list
         * @return
         */
        private List<ResultData> uqValid(List<Map<String ,String >> list){
            List<ResultData> resultlist=new ArrayList<>();
            List<String> classNameErr=new ArrayList<>();        //存放错误的信息
            int i=0;
            for(Map<String ,String > m:list){
                if(tableName!=null && tableName.contains("courseManage")){
                    i++;
                    //检测
                    /**
                     * 添加字段，以及这几个字段值的非空判断
                     */
                    int  a=m.size();
                    String value=m.get("courseCode");
                    if(value==null || value.equals(""))
                        classNameErr.add("第 "+i+" 行:课程代码为空");
                    value=m.get("chineseName");
                    if(value==null || value.equals(""))
                        classNameErr.add("第 "+i+" 行:中文名称为空");
                    value=m.get("englishName");
                    if(value==null || value.equals(""))
                        classNameErr.add("第 "+i+" 行:英文名称为空");
                    value=m.get("courseCategory_3");
                    if(value==null || value.equals(""))
                        classNameErr.add("第 "+i+" 行:课程类别三为空");
                    value=m.get("courseCategory_4");
                    if(value==null || value.equals(""))
                        classNameErr.add("第 "+i+" 行:课程类别四为空");
                    value=m.get("courseCategory_5");
                    if(value==null || value.equals(""))
                        classNameErr.add("第 "+i+" 行:课程类别五为空");
                    value=m.get("totalCredit");
                    if(value==null || value.equals(""))
                        classNameErr.add("第 "+i+" 行:学分为空");
                    value=m.get("totalTime");
                    if(value==null || value.equals(""))
                        classNameErr.add("第 "+i+" 行:学时为空");
                    value=m.get("courseStatus");
                    if(value==null || value.equals(""))
                        classNameErr.add("第 "+i+" 行:课程状态为空");
                    value=m.get("teacherNumber");
                    if(value==null || value.equals(""))
                        classNameErr.add("第 "+i+" 行:负责教师工号为空");
                }else{
                    classNameErr.add("表格名不正确");
                }
            }
            //验证
            if(classNameErr.size()>0){
                ResultData re=new ResultData();
                re.sets(1,"课程名称、中文名称、英文名称、课程类别三、课程类别四、课程类别五、学分、学时、课程状态、负责教师 数据有错误");
                re.setData(classNameErr);
                resultlist.add(re);
            }
            return resultlist;
        }

        /**
         * 检查课程信息是否已存在
         * @param list
         * @return
         */
        private ResultData primaryKeyValid(List<Map<String ,String >> list){
            ResultData resultData=new ResultData();
            List<String > temp=new ArrayList<>();
            List<Map<String ,String >> list1= null;
            int i=0;
            for(Map<String ,String > map:list) {
                i++;
//            Map<String ,String > key=studentPaymentService.getKey(map);
                if(i%batch!=0){
                    try{
                        //根据文件名字的不同，调用不同的service
                        if(tableName.contains("courseManage")){
                            list1 = list.subList(i-1,i);
                            List<String > keys= courseManageService.getCourseCode(list1);
                            temp.addAll(keys);
                            if(temp.size()!=0){
                                resultData.sets(1,"第"+i+"行课程代码已存在");
                                return resultData;
                            }
                            temp.clear();
                            List<String > courseNameList= courseManageService.getCourseName(list1);
                            if(courseNameList.size() > 0){
                                resultData.sets(1,"第"+i+"行课程名称已存在");
                                return resultData;
                            }
                        }
                    }catch (Exception e){
                        e.getStackTrace();
                        String msg=e.getMessage();
                        resultData.sets(2,"第"+i+"行课程信息已存在，可能原因："+e.getMessage().substring(0,msg.length()>2000?2000:msg.length()));
                        return resultData;
                    }
//                list.clear();
                }
            }
            return resultData;
        }
}
