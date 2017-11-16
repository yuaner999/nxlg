package com.liuzg.jsweb.controllers;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.commons.fileupload.DiskFileUpload;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.util.Streams;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.nio.file.Paths;
import java.util.*;

/**
 * Created by meteorlu on 2016-12-31.
 */
public class FileUploader implements Controller {

    String uploadFolder;
    boolean isRelativePath = true;
    @Override
    public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String filename = UUID.randomUUID().toString();
        String fid = filename;
        File file = null;
        String tag = request.getParameter("tag");
        do{
            if(isRelativePath) filename = Paths.get(request.getRealPath("/"),uploadFolder,filename).toFile().getAbsolutePath();
            else filename = Paths.get(uploadFolder,filename).toFile().getAbsolutePath();

            file = new File(filename);
        }while(file.exists());

        try{
            DiskFileItemFactory factory = new DiskFileItemFactory();
            factory.setSizeThreshold(4096);
            factory.setRepository(new File(filename).getParentFile());

            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setSizeMax(1000000000);
            List fileItems = upload.parseRequest(request);
            Iterator iter = fileItems.iterator();
            while (iter.hasNext()) {
                FileItem item = (FileItem) iter.next();
                if(item.getContentType()==null|| Objects.equals(item.getContentType(), "")){
                }else{
                    item.write(new File(filename));
                }
            }

            HashMap<String,Object> result = new HashMap<>();
            result.put("fid",fid);
            result.put("tag",tag);
            response.setContentType("application/json");

            ObjectMapper mapper = new ObjectMapper();
            String json = mapper.writeValueAsString(result);
            response.getWriter().write(json);
        }catch (Exception e){
            e.printStackTrace();
        }

        return null;
    }

    public void setUploadFolder(String uploadFolder) {
        this.uploadFolder = uploadFolder;
    }

    public void setRelativePath(boolean relativePath) {
        isRelativePath = relativePath;
    }
}
