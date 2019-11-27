package com.ecspace.business.accountCenter.administrator.controller;

import com.ecspace.business.accountCenter.administrator.entity.Department;
import com.ecspace.business.accountCenter.administrator.entity.Users;
import com.ecspace.business.accountCenter.administrator.service.DepartmentService;
import com.ecspace.business.accountCenter.administrator.service.UsersService;
import com.ecspace.business.accountCenter.util.*;
import com.sun.org.apache.regexp.internal.RE;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/department")
public class DepartmentController {

    @Autowired
    private DepartmentService departmentService;

    @Autowired
    private UsersService usersService;

    @RequestMapping("/list")
    public void list(HttpServletRequest request, HttpServletResponse response){
        JSONObject resultObject = new JSONObject();
        List<Department> list = departmentService.list(new HashMap<>());
        resultObject.put("code", ResultMessage.success);
        resultObject.put("result", JSONArrayUtil.listToJsonArray(list));
        ResponseUtil.write(response,resultObject);
    }

    @RequestMapping("/listTree")
    public void listTree(HttpServletRequest request, HttpServletResponse response){
        String id = request.getParameter("id");
        JSONArray jsonArray = new JSONArray();

        if(id == null || "".equals(id)){
            //第一次加载
            //使用默认值
            String[] jsonString = new String[]{"所有账户","临时账户","部门"};
            for(int i = 0;i<jsonString.length;i++){
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("id","200"+(i+1));
                jsonObject.put("text",jsonString[i]);
                if(!jsonString[i].equals("所有账户")){
                    jsonObject.put("state","closed");
                }
                jsonArray.add(jsonObject);
            }
        }else{
            Map<String, Object> map = new HashMap<>();
            map.put("pDepartmentTNO",id);
            List<Department> list = departmentService.list(map);
            jsonArray = assembleTree(list);
        }

        ResponseUtil.write(response,jsonArray);



    }

    /**
     * 组装eastyu-tree需要的数据
     * @param list
     * @return [{"id":"0201","text":"zxc-2-1"}]
     */
    private JSONArray assembleTree(List<Department> list){
        JSONArray jsonArray = new JSONArray();
        if(list != null){
            for(int i = 0 ;i<list.size();i++){
                JSONObject jsonObject = new JSONObject();
                Department department = list.get(i);
                jsonObject.put("id",department.gettNO());
                jsonObject.put("text",department.getDepartmentName());
                if("2".equals(department.getStatus())){
                    //代表有子节点
                    jsonObject.put("state","closed");
                }
                jsonArray.add(jsonObject);
            }
        }

        return jsonArray;
    }

    @RequestMapping("/save")
    public void save(Department department, HttpServletRequest request, HttpServletResponse response)throws Exception{
        JSONObject resultObject = new JSONObject();
        department.settNO(StringUtil.goOutSpace(department.gettNO()));
        department.setDepartmentName(StringUtil.goOutSpace(department.getDepartmentName()));

        //判断参数是否合法
        if(department.getDepartmentName() == null){
            resultObject.put("code", ResultMessage.parameterNotValid);
            ResponseUtil.write(response,resultObject);
            return;
        }

        String result = ResultMessage.defeated;

        //新建
        department.settNO(IdGenerator.generate());
        department.setInputDate(DateUtil.getDate());
        department.setInputUser(ReadData.administrator);


        //保存新增的数据
        if(departmentService.save(department)){
            result = ResultMessage.success;
        }
        //判断上级目录是否为空
        String pTNO = department.getpDepartmentTNO();
        if(pTNO != null && !"".equals(pTNO)){
            if (!"2001".equals(pTNO) || !"2002".equals(pTNO) || !"2003".equals(pTNO)) {
                //通过上级目录tNO查询是否有子节点
                Map<String, Object> map = new HashMap<>();
                map.put("pDepartmentTNO", pTNO);
                List<Department> list = departmentService.list(map);
                if (list == null || list.size() == 1) {
                    //证明是第一次新建子节点，修改节点状态
                    Department department1 = new Department();
                    department1.settNO(pTNO);
                    department1.setStatus("2");
                    departmentService.update(department1);
                }
            }
        }

        resultObject.put("code",result);
        resultObject.put("tNO",department.gettNO());
        ResponseUtil.write(response,resultObject);

    }

    @RequestMapping("/update")
    public void update(Department department, HttpServletRequest request, HttpServletResponse response)throws Exception{
        JSONObject resultObject = new JSONObject();
        department.settNO(StringUtil.goOutSpace(department.gettNO()));
        department.setDepartmentName(StringUtil.goOutSpace(department.getDepartmentName()));


        //判断参数是否合法
        if(department.gettNO()== null || department.getDepartmentName() == null){
            resultObject.put("code", ResultMessage.parameterNotValid);
            ResponseUtil.write(response,resultObject);
            return;
        }

        String result = ResultMessage.defeated;
        department.setEditUser(ReadData.administrator);
        department.setEditDate(DateUtil.getDate());
        //执行更新操作
        if(departmentService.update(department)){
            result = ResultMessage.success;
        }
        //更新保存在用戶的部门名称
        Users users = new Users();
        users.setCompanyName(department.getDepartmentName());
//        updateUsers.updateUsers(users);

        resultObject.put("code",result);
        ResponseUtil.write(response,resultObject);
    }

    @RequestMapping("/delete")
    public void delete(HttpServletRequest request, HttpServletResponse response)throws Exception {
        String tNO = request.getParameter("tNO").trim();
        JSONObject resultObject = new JSONObject();
        String result = ResultMessage.defeated;
        //删除目录
        if (departmentService.delete(tNO)) {
            result = ResultMessage.success;
        }
        //判断上级目录是否需要改变状态
        String pDepartmentTNO = request.getParameter("pDepartmentTNO");
        if (pDepartmentTNO != null && !"".equals(pDepartmentTNO)) {
            if (!"2001".equals(pDepartmentTNO) || !"2002".equals(pDepartmentTNO) || !"2003".equals(pDepartmentTNO)) {
                //通过上级目录tNO查询是否还有子节点
                Map<String, Object> map = new HashMap<>();
                map.put("pDepartmentTNO", pDepartmentTNO);
                List<Department> list = departmentService.list(map);
                if (list == null || list.size() == 0) {
                    //没有子节点,需要修改状态
                    Department department = new Department();
                    department.settNO(pDepartmentTNO);
                    department.setStatus("1");
                    departmentService.update(department);
                }
            }
        }
        resultObject.put("code", result);
        ResponseUtil.write(response, resultObject);
    }




}
