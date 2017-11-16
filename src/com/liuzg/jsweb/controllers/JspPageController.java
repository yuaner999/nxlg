package com.liuzg.jsweb.controllers;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by Administrator on 2017/1/1.
 */


public class JspPageController implements Controller {


    @Override
    public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse httpServletResponse) throws Exception {
        ModelAndView modelAndView = new ModelAndView();
        String jspfile = request.getRequestURI().substring(request.getContextPath().length()).substring("views/".length()).replace(".form","");
        modelAndView.setViewName(jspfile);
        return modelAndView;
    }
}
