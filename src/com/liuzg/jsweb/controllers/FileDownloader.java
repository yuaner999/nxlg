package com.liuzg.jsweb.controllers;

import org.apache.commons.fileupload.util.Streams;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.nio.file.Paths;
import java.util.Map;

/**
 * Created by meteorlu on 2016-12-31.
 */
public class FileDownloader implements Controller {

    String uploadFolder;
    String filenameVar;
    String contentType = "application/octet-stream";
    boolean isRelativePath=true;

    public FileDownloader() {
        uploadFolder = null;
    }

    @Override
    public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String pfilename = request.getParameter(filenameVar);

        try{
            String imgfilename = pfilename;
            String filename = "";
            if(isRelativePath) filename = Paths.get(request.getRealPath("/"),uploadFolder,imgfilename).toFile().getAbsolutePath();
            else filename = Paths.get(uploadFolder,imgfilename).toFile().getAbsolutePath();

            File file = new File(filename);
            if(!file.exists()) {
                response.setStatus(500);
                return null;
            }
            FileInputStream fileInputStream = new FileInputStream(filename);
            Streams.copy(fileInputStream, response.getOutputStream(),true);
            fileInputStream.close();
        }catch (Exception e){
            e.printStackTrace();
        }

        response.setContentType(contentType);
        return null;
    }

    public void setUploadFolder(String uploadFolder) {
        this.uploadFolder = uploadFolder;
    }

    public void setFilenameVar(String filenameVar) {
        this.filenameVar = filenameVar;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public void setRelativePath(boolean relativePath) {
        isRelativePath = relativePath;
    }
}
