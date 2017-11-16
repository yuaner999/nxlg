package com.liuzg.jsweb.controllers;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Created by liuzg on 2017/2/18.
 */
public class HtmlWorkspaceController implements Controller {

    private static String workspaceDir;

    public void setWorkspaceDir(String workspaceDir2){
        workspaceDir = workspaceDir2;
    }

    @Override
    public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse httpServletResponse) throws Exception {
        String relativefilename = request.getRequestURI().substring(request.getContextPath().length()).substring("workspace/".length());
        Path filepath = Paths.get(workspaceDir, relativefilename);
        File file = filepath.toFile();
        FileInputStream fin = new FileInputStream(file);
        byte[] buffer = new byte[1024*5];
        int readed = fin.read(buffer);
        while(readed>0){
            httpServletResponse.getOutputStream().write(buffer,0,readed);
            readed = fin.read(buffer);
        }
        fin.close();
        httpServletResponse.getOutputStream().flush();
        return null;
    }
}
