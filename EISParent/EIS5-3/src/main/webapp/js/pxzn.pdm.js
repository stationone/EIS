		$(function(){
			$('.modal').dialog({
				modal:true
			});
			
			
					//菜单栏目录显示隐藏状态1
				$('#div_menu_i').mouseenter(function(){
					
					$('#div_menu_ul').toggle();
					// $("#div_menu_ul").animate({height:"200px"});
				});

				//菜单栏目录显示隐藏状态2
				$('#div_menu_ul').mouseleave(function(){
					
					$('#div_menu_ul').css('display','none');
					if(li_u != ""){
						$('#'+li_u).css('display','none');
					}
					
				});
				
				/*********************左侧二级导航栏菜单显示**************************/
				//菜单栏目录显示隐藏状态1
				$('#div_left_menu_i').mouseenter(function(){
					
					$('#div_left_menu_ul').toggle();
					// $("#div_menu_ul").animate({height:"200px"});
				});

				//菜单栏目录显示隐藏状态2
				$('#div_left_menu_ul').mouseleave(function(){
					
					$('#div_left_menu_ul').css('display','none');
					if(li_u != ""){
						$('#'+li_u).css('display','none');
					}
					
				});
		});
			

			/**
			 * 获取地址参数
			 * 返回json 
			 * {userName: "一般员工", type: "1"}
			 * 级别 type
			 * 管理员 s
			 * xxx模块管理员 m
			 * 一般员工 1
			 */
			function getUrlParameter(){
			
				var url = decodeURI(location.search);
				//?userName=一般员工&type=1
				var data = "{";
				if(url != ""){
					url = url.split("?");
					if(url.length != 0){
						for(var i = 0;i<url.length;i++){
							if(url[i] != ""){
								url = url[i].split("&");
								if(url.length != 0){
									for(var j = 0 ;j<url.length ;j++){
										//userName=一般员工
										 var urljson = url[j].split("=");
										 data += "\""+urljson[0]+"\":\""+urljson[1]+"\",";
									}
									
								}
								break;
							}
						};
		
					}	
				}
				// data = data.substring(0,data.length-1)+"}";
				data = data.substring(0,data.length-1)+"}";
				console.log(data);
				var datajson = null;
				if(data != ""){
					datajson = eval('('+data+')');
				}

				return datajson;
				
			}



			/**
			 *拼接一级导航栏目录
			 *传入json数据源
			 */			
			function assemblyMainLabel(data){
				var datas = "";
				if(data != null){
					var length = new Array();
					var arrays = new Array();
					for(var i = 0;i<data.length;i++){
					 arrays[data[i].order] ='<li>'+
											'<a href="'+data[i].moduleURL+'" onclick="editIframe(this);return false">'+
											'<div id="'+data[i].moduleNO+'" onclick="editColor(this)" class="mainlable_div mainlableborder ">'+
												// '<i class="iconfont '+data[i].icon+'"></i>'+
						 						'<img class="mainlable_img" src="images/px-icon/'+data[i].icon+'"/>'+
												'<span class="font_margin">'+data[i].moduleName+'</span>'+
						 						'<div id="mainlable_div"></div>'+
												'</div>'+
											'</a>'+	
								    		'</li>';
					 length[i] = data[i].order;		    		
					}
					
					if(arrays.length > 0){
						if(length.length > 0){
							
							//通过排序算出arrays下标的先后顺序
							var lengths = 0;
							for(var i = 0;i < length.length;i++){
								for(var j = 0;j<length.length-i-1;j++){
									if(length[j]>length[j+1]){
										lengths = length[j];
										length[j] = length[j+1];
										length[j+1] = lengths;
									}
								}
							}
							
							for(var i = 0;i<length.length;i++){
								datas += arrays[length[i]];
							}
						}
					
					}
				
				}
				
					
				return datas;
			}
			



			/**
			 *修改左侧目录点击后的颜色
			 *传入对象
			 *
			 */
			function updatacolor(data){
				
				if(data != null){
					var id = data.id;
					var ul_main = data.parentNode.parentNode.parentNode.childNodes;
				
					if(ul_main != null){
						for(var i = 0;i<ul_main.length;i++){
							
							if(ul_main[i].hasChildNodes()){

								var li_li = ul_main[i].childNodes;
								if(li_li != null){
									for(var u = 0;u<li_li.length;u++){
										if(li_li[u].hasChildNodes()){
											var lis = li_li[u].childNodes;
												if(lis != null){
													for(var u = 0;u<lis.length;u++){
														if(lis[u].hasChildNodes()){
															
															if(lis[u].getAttribute('id') == id){
																lis[u].setAttribute('class','mainlable_div mainlablecolor');
															}else{
																lis[u].setAttribute('class','mainlableborder mainlable_div');
															};
														}
													}
												}
										}
									}	
								}
								
							}
						}
						
					}
				}
			}
			
			/**
			 *页面首次加载的子页面
			 *iframeId 需要修改src的iframe标签id;
			 *Id ul标签的Id
			 */
			function firstIframe(iframeId,Id){
			/*  <li>
					<a href="system/users.jsp" onclick="editIframe(this);return false">
						<div id="14" onclick="editColor(this)" class="mainlableborder "><i class="iconfont "></i>
							<span class="font_margin">用户管理</span>
						</div>
					</a>
				</li> */
				
				//传入对象Id的子节点
				if(document.getElementById(Id).hasChildNodes()){
					var datas = document.getElementById(Id).childNodes;
					
					for(var i = 0 ; i<datas.length ; i++){
						if(datas[i].hasChildNodes()){
							
							var datasli = datas[i].childNodes; 
							for(var p = 0 ; p<datasli.length ; p++){
								if(datasli[p].hasChildNodes()){
									var dataslis = datasli[p].childNodes;
									for(var u = 0 ; u<dataslis.length ; u++){
										//修改子页面的跳转地址
										$("#"+iframeId).attr('src',datasli[p].href);
										$("#"+dataslis[u].id).attr("class","mainlablecolor mainlable_div");
										return;
									}
									
								}
								
							}
							
						}
						
					}
				}
			
			}

			
			/**
			 *组装二级导航菜单表
			 *传入json数据
			 *[{'name':'权限设置','icon':'','childs':[{'name':'单个设置知识权限','icon':''},{'name':'批量设置知识权限','icon':''}]}]
			 *传出<li>拼接完成标签
			 */
			var li_left_s = 1;
			function assembleTable_left(data){
				var datas = "";
				for(var i = 0;i<data.length;i++){
					if(data[i].position == "1"){
						if(data[i].childs){
							//有子类的
	
			    			var childsli = assembleTable(data[i].childs);
			    			datas +='<li id="li_left_'+li_s+'" onmouseenter="openso_left(this)" onclick="'+data[i].event+'" >'+
			    						'<i class="iconfont '+data[i].iconfont+'"></i>'+
			    						'<a href="">'+data[i].name+'<i class="iconfont '+data[i].iconfonts+'" style="float: right;"></i></a>'+
			    						'<ul id="li_left_'+li_s+'_ul" style="position: absolute;width: 178px;left: -170px;margin-top: -22px; display: none;">'+
			    							childsli+
			    						'</ul>'+
			    					'</li>';	
			    			li_s++;
	
						}else{
							//无子类的

							datas += '<li onmouseenter="" onclick="'+data[i].event+'"><i class="iconfont '+data[i].icon+'"></i><a href="#">'+data[i].name+'</a></li>'
						};
					}
						
					
				
				}
				return datas;
			}
			

			/**
			 *组装右侧菜单表
			 *传入json数据
			 *[{'name':'权限设置','iconfont':'','childs':[{'name':'单个设置知识权限','iconfont':''},{'name':'批量设置知识权限','iconfont':''}]}]
			 *传出<li>拼接完成标签
			 */
			var li_s = 1;
			function assembleTable(data){
				var datas = "";
				for(var i = 0;i<data.length;i++){
					if(data[i].setting == "1"){
						if(data[i].childs){
							//有子类的

			    			var childsli = assembleTable(data[i].childs);
			    			datas +='<li id="li_'+li_s+'" onmouseenter="openso(this)" onclick="'+data[i].click+'" >'+
			    						'<i class="iconfont '+data[i].iconfont+'"></i>'+
			    						'<a>'+data[i].name+'<i class="iconfont '+data[i].iconfonts+'" style="float: right;"></i></a>'+
			    						'<ul id="li_'+li_s+'_ul" style="position: absolute;width: 178px;left: -170px;margin-top: -22px; display: none;">'+
			    							childsli+
			    						'</ul>'+
			    					'</li>';	
			    			li_s++;

						}else{
							//无子类的

							datas += '<li onmouseenter="openso(this)" onclick="'+data[i].url+'"><i class="iconfont '+data[i].icon+'"></i><a>'+data[i].funcName+'</a></li>'
						};
					}
					

				}
				return datas;
			}

			/**
			 *菜单栏子标签的显示隐藏
			 *传入对象
			 */
			var li_u = '';
			function openso(data){	
				//获取当前标签的Id,id为空则无下级条目
					
				if(data.id != ""){
					//id不为空
					$('#'+data.id+'_ul').toggle();
					li_u = data.id+'_ul';
				}else{
					//id为空
					var li = data.parentNode.childNodes;
					for(var i = 0 ;i<li.length;i++){
						
						if(li[i].hasChildNodes()){
			
							if(li[i].id != ''){
								$('#'+li[i].childNodes[2].id).css('display','none');
								li_u = "";
							}
							
						}
						
					}

				}
			}	
			






/**
 * 表格栏行尾菜单
 */

					
			/**
			 * 设置表格菜单栏div属性
			 * data ，this对象
			 * type , display的值(bolck or none)
			 */
			function setDivDisplay(data,type){
				var datas = data.childNodes;
				for(var i = 0;i<datas.length;i++){
					if(datas[i].nodeName == "DIV"){
						datas[i].setAttribute("style","display:"+type);
					}
				}
			}
			
					//鼠标移上操作
					function datagrid_menu_mouseenter(data){
						setDivDisplay(data,"block");
					}
					//鼠标移下操作
					function datagrid_menu_mouseleave(data){
						setDivDisplay(data,"none");
					}
			



/**
 * 设置菜单栏显示方法
 * 这方法只是在无后台时使用
 */

     		/**
			 * 根据权限设置能否访问菜单栏
			 * 管理员 s
		 	 * 模块管理员 m
		 	 * 一般员工 1
			 */
			function setMenu(adminData,moduleData,userData){
			
				var type = parent.getUrlParameter().type;
				if(type == "s"){
					
					//设置目录菜单栏
					menuOperate("1",adminData);
					//设置右侧目录
					menuOperate("2",adminData);
					//设置表格菜单
					menuOperate("3",adminData);
					
				}else if(type == "m"){
					//设置右侧目录
					menuOperate("2",moduleData);
					menuOperate("3",moduleData);
				}else if(type == "1"){
					//设置右侧目录
					menuOperate("2",userData);
					menuOperate("3",userData);
				}
			}
			
			
			/**
			 * 菜单操作
			 * type 类型
			 * 1：左侧目录
			 * 2：右侧菜单
			 * 3：表格尾部操作
			 */
			var operateList = "";
			function menuOperate(type,data){
				var datas = "";
				if(type == "1"){
					if(data != ""){
						var datali = assembleTable_left(data);
						if(datali != ""){
							document.getElementById("div_left_menu_ul").innerHTML = assembleTable_left(data);
							document.getElementById("div_left_menu").style.display="block";
							return;
						}
					
					}

						
				}else if(type == "2"){
					if(data != ""){
						for(var i = 0 ;i<data.length;i++){
							if(data[i].position == "2" || data[i].position == "4"){
								datas += '<li onmouseenter="openso(this)" onclick="'+data[i].event+'">'
										  +'<i class="iconfont '+data[i].icon+'"></i><a>'+data[i].name+'</a>'
										 +'</li>';	
							}
						}
						
						if(datas == ""){
							document.getElementById("div_menu_i").style.display="none";
							return;
						}
							document.getElementById("div_menu_ul").innerHTML= datas;
							return;
					}
					document.getElementById("div_menu_i").style.display="none";
					
					
					
				}else if(type == "3"){
					operateList = data;
				}
				
				
			}	
			
			/**
     		 * 表格尾部操作图标
     		 */
     		function operate(value,rowData,rowIndex){

     			var click ="";
     			if(operateList != ""){
 				    click ='<i class="iconfont icon-biaogeweibucaidan" onmouseenter="datagrid_menu_mouseenter(this)" onmouseleave="datagrid_menu_mouseleave(this)">'
					      +'<div  class="datagrid_menu_div" >';
					for(var i = 0;i<operateList.length;i++){
						if(operateList[i].position == "3" || operateList[i].position == "4"){
							var e = operateList[i].event.substring(0,operateList[i].event.length-2);
								click += '<a onclick="'+e+'(\''+rowIndex+'\')">'+operateList[i].name+'</a>';
						}
					}
					
					click += '</div></i>';
					
				}
     			return click;
     		}



			/**
			 * 设置一级导航栏
			 * 传入数据
			 * [{"moduleNO":"1","moduleName":"用户管理","moduleURL":"systemManagement/userManagement.html","icon":"","event":"","order":1}
			 * ,{"moduleNO":"2","moduleName":"角色管理","moduleURL":"systemManagement/roleManagement.html","icon":"","event":"","order":2}
			 * ,{"moduleNO":"3","moduleName":"模块菜单管理","moduleURL":"systemManagement/moduleManagement.html","icon":"","event":"","order":3}
			 * ,{"moduleNO":"4","moduleName":"模块操作管理","moduleURL":"systemManagement/functionManagement.html","icon":"","event":"","order":6}
			 * ];
			 * @param {Object} data
			 */
			function setOneNavigationBar(data){
				//清空左侧目录					
				$('#mainlable').empty();

				$('#mainlable').append(assemblyMainLabel(data));
				console.log(data);

				//获取最小数
				var orderSmall = 0;
				var smallData;
				for(var i = 0 ;i<=data.length-1;i++){
					var order = data[i].order;
					if(orderSmall == 0){
						orderSmall = order;
						smallData = data[i];
						continue;
					}
					if(orderSmall > order){
						orderSmall = order;
						smallData = data[i];
						continue;
					}

				}



					//设置页面首次加载打开的页面,默认是一级导航栏的第一个参数
				// firstIframe("iframe_2","mainlable");

				//设置默认加载页面
				editColor(document.getElementById(smallData.moduleNO));
				editIframe(document.getElementById(smallData.moduleNO).parentNode);
			}
			


			/**
			 * 废弃，在centerPage重写了
			 * 一级导航点击后跳转操作
			 * @param {Object} data
			 */
			function editIframe(data){
				// var centerPages = document.getElementById("iframe_centerPage");
				// var childNodes = centerPages.childNodes;
				// if(childNodes != null){
				// 	for(var i = 0;i<childNodes.length;i++){
				// 		var childNode = childNodes[i];
				// 		if(childNode.nodeName === "IFRAME"){
				// 			console.log(childNode.src);
				//
				// 		}
				// 	}
				// }
				$('#iframe_2').attr('src',data.href);

			}
			
			/**
			 * 一级导航栏点击后变色
			 * @param {Object} data
			 */
			function editColor(data){
				//左侧目录点击后变色
				updatacolor(data);
				
			}
			

			//返回消息指
			function returnMessage(result){
				
			}
