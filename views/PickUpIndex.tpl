<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>拣选</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <link rel="icon" 
          type="image/png" 
          href="/images/logo_pure.png"> 
    <link href="/bootstrap/css/bootstrap.css" rel="stylesheet" media="screen">    
    <style type="text/css">
      td.highlight {
          background-color: rgba(0,256,0, 0.1) !important;
      }
      tr.highlight{
          background-color: rgba(0,256,0, 0.1) !important;
      }
      #dtProcess{
        text-align: center;
      }
      th{
        text-align: center;
      }
      .title{
        font-size: 35px;
        font-weight: 800;
        margin-bottom: 10px;
      }
    </style>

    <script src="/javascripts/jquery.min.js" type="text/javascript"></script> 
    <script src="/bootstrap/js/bootstrap.min.js"></script>
  </head>
  <body >

      <nav class="navbar navbar-default navbar-fixed-top" style="text-align: center;background-color: rgba(0,128,0,0.8);">
        <div class="container">
          <div class="row" id = "subNavBar" style="">
            <div class="col-xs-5 col-sm-5 col-md-5 col-md-lg-5" style="text-align: left;cursor:pointer;" onclick="window.location.href='/'">
                <img src="/images/logo_pure.png" class="img-responsive" alt="Responsive image" style="width: 35px; margin-top: 6px;float: left;margin-right: 10px;">
                <div style="color: rgba(256,256,256,1); padding-top: 10px; font-size: 18px; margin-left: -50px;">配送站拣选系统</div>
            </div>
            <div class="col-xs-3 col-sm-3 col-md-3 col-md-lg-3" style="text-align: left;"> </div>
              <div class="col-xs-1 col-sm-1 col-md-1 col-md-lg-1">
                  <!-- <a class="btn btn-link" href="/PickUpIndex" role="button" style="width: 100%; color: rgba(256,256,256,0.9); padding-top: 10px; font-size: 16px;">拣选</a> -->
              </div>
 
              <div class="col-xs-1 col-sm-1 col-md-1 col-md-lg-1"> </div>

              <div class="col-xs-1 col-sm-1 col-md-1 col-md-lg-1">
                  <!-- <a id="pickupShelfID" class="btn btn-link" href="" role="button" style="width: 100%; color: rgba(256,256,256,1); padding-top: 10px; font-size: 16px;text-decoration: none; cursor: default;">{{.ShelfID}}号拣选墙</a> -->
              </div>                             
              <div class="col-xs-1 col-sm-1 col-md-1 col-md-lg-1">
                  <!-- <a class="btn btn-link" href="/PickUpIndex?ShelfID={{.ShelfID}}" role="button"  style="width: 100%;color: rgba(256,256,256,0.6); padding-top: 10px; font-size: 16px;">切换</a>    -->
              </div>   
          </div>
      </nav>


      <div class="container" style="margin-top:65px;">
        <div id ="mainInfoWall" class="row" style="background-color: rgba(86,146,51,0.25);box-shadow: 0px 6px 4px rgba(1,1,1,0.4);">
            <div class="col-xs-12 col-sm-12 col-md-12 col-md-lg-12" style="text-align: center;margin-top: 15px;">
              <div style="text-align: center; color: rgba(0,0,0,0.3); font-size: 14px;">配送员</div>
            </div>
            <div class="col-xs-12 col-sm-12 col-md-12 col-md-lg-12" style="text-align: center;">
              <div id="LocationID" style="text-align: center; font-size: 120px;margin-bottom: -10px;margin-top: -30px;">无 </div>
            </div>
            <div class="col-xs-12 col-sm-12 col-md-12 col-md-lg-12" style="text-align: center;">
              <div style="text-align: center; color: rgba(0,0,0,0.3); font-size: 14px;">剩余订单数</div>
            </div>
            <div class="col-xs-2 col-sm-2 col-md-2 col-md-lg-2" style="text-align: center;"> </div>
            <div class="col-xs-8 col-sm-8 col-md-8 col-md-lg-8" style="text-align: center;">
              <div id="ordersProgressValue" style="text-align: center; font-size: 50px;margin-top: -10px; color: rgba(1,1,1,0.5);margin-bottom: 20px;cursor: pointer;text-decoration: underline;" onclick="ToUncompltedDetail()" >0 </div>
            </div>
            <div class="col-xs-2 col-sm-2 col-md-2 col-md-lg-2" style="text-align: center;"> 
              <!-- <div id ="uncompletdOrdersDetail" style="text-align: center; font-size: 18px; margin-top: 27px; color: rgba(1,1,1,0.3); margin-bottom: 20px; cursor: pointer; text-decoration: underline;">详情 </div> -->
            </div>

        </div>

        <div class="row" style="margin-top: 35px;">
            <div style="margin-top: 0px; margin-bottom: 0px; border-top: solid 1px rgba(0,0,0,0.2);"></div>
            <div class="progress" style="-webkit-box-shadow: inset 0 1px 2px rgba(0, 0, 0, .0);background-color: white;">
              <div id="progressShow" class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width: 0%;height:20%;">
                <span class="sr-only">40% Complete (success)</span>
              </div>
            </div>
        </div>

        <div class="row" style="background-color: rgba(111,111,111,0.05); box-shadow: 0px 1px 1px rgba(111,111,111,0.3); margin-top: -10px;">
            <div id="ProductName" style="text-align: center; font-size: 20px;margin-bottom: 20px; margin-top: 20px;"></div>
        </div>
            <!-- <div id="output" style="text-align: center; font-size: 20px; margin-bottom: 0px;">测试测试</div> -->
        <div class="row" style="margin-top: 35px;">
            <input type="text" class="form-control" id="inputID" placeholder="" value="" style="text-align: center;">
        </div>
            <!-- <button type="button" class="btn btn-success btn-small" onclick="submitOrder()">&nbsp;&nbsp;提 &nbsp; 交&nbsp;&nbsp;</button> -->


      </div>
      <nav class="navbar navbar-default navbar-fixed-bottom">
        <div class="container">
              <div class="col-xs-12 col-sm-12 col-md-12 col-md-lg-12">
                <div id="blurAlert" class="alert alert-danger" role="alert" style="text-align: center;font-size:20px;"></div>
              </div>
        </div>
      </nav> 

    <script>
    var tempInput = ""
    var pauseCount = 5
    var pauseMaxCount = 5

    var err = 101
    var orderCompleted = 102
    var productOK = 103
    var noEmptyLocation = 104
    var orderLocated = 105

    function submitOrder() {
        if (pauseCount >= 0) {
            $("#inputID").val("")
            RefreshProgress()
            pauseCount--
            return
        }


        //***************************************************
        //条码枪没有后缀的解决方案

        var newInput = $("#inputID").val()
            // if(newInput.length > 0){
            //   console.log("新输入值：" + newInput)
            // }
        if (newInput.length > 0) {
            if (newInput == tempInput) {
                console.info("输入值确定为：" + newInput)
                tempInput = ""
                $("#inputID").val("")
                newInput = newInput.replace(/\*/g, "")
                request(newInput)
            } else {
                tempInput = newInput
            }
        }
        return
        //***************************************************

    }
    function setLocationIDAlert(value){
      if(value == null){
        value = "无"
      }
        $("#LocationID").css("color", "rgb(210,0,0)")
        $("#LocationID").text(value)
    }
    function setLocationIDNormal(value){
        if(value == null){
          value = "无"
        }
        $("#LocationID").css("color", "black")
        $("#LocationID").text(value)
    }
    function setProductName(value){
        if(value == null){
          value = ""
        }
        $("#ProductName").text(value)
    }
    // function setAlertInfo(value){
    //   $("#output").css("color", "rgb(210,0,0)")
    //   $("#output").text(value)
    // }
    // function setNormalInfo(value){
    //     $("#output").css("color", "black")
    //     $("#output").text(value)
    // }
    function request(id){
          if(id.length <= 0) return
          HideAlertMessage()
          PauseInput()
          $.get("/SubmitPickupID?ID=" + id , function(data) {
                console.log(data)
                switch (data.StateCode) {
                    case -1://其它错误
                        setLocationIDAlert()
                        setProductName()
                        ShowAlertMessage(data.Err)
                        break;
                    case 0://查找成功
                        setLocationIDNormal(data.ExpressmanID)
                        setProductName("【" + data.RequestID + "】分配给配送员【" + data.ExpressmanID+"】")
                        // RefreshUncompletedOrdersCount()
                        HideAlertMessage()
                        break;
                    case 1://没有订单与配送员的绑定信息
                        setLocationIDAlert()
                        setProductName()
                        ShowAlertMessage(data.Err)
                        break;
                    case 2://没有订单需要该商品
                        setLocationIDAlert()
                        setProductName()
                        ShowAlertMessage(data.Err)
                        break;
                }
            })
    }
    function RefreshProgress(){
      if(pauseCount < 0){
        pauseCount = 0
      }
      $("#progressShow").css("width", (pauseCount * 20) + "%")
    }
    function RefreshUncompletedOrdersCount(){
      $.get("/GetUncompltedOrdersCount", function(data){
        if(data == null){
          console.error("系统异常")
        }else{
          // console.log(data)
          if(data.Code != 0){
            console.warn(data.Message)
            ShowAlertMessage(data.Message)
          }else{
            $("#ordersProgressValue").text(data.Data)
            if(data.Data <= 0){
              // $("#mainInfoWall").css("background-color", "rgba(248,231,28,0.4)")
              $("#mainInfoWall").css("background-color", "rgba(111,111,111,0.05)")
              // $("#uncompletdOrdersDetail").hide()
            }else{
              $("#mainInfoWall").css("background-color", "rgba(248,231,28,0.4)")
              // $("#mainInfoWall").css("background-color", "rgba(86,146,51,0.25)")
              // $("#uncompletdOrdersDetail").show()

            }
          }
        }
      })
    }
    function PauseInput(){
      pauseCount = 5
      RefreshProgress()
    }
    $(document).ready(function() {
        prepareBarcodeInput()
        RefreshUncompletedOrdersCount()
        // window.onfocus = function(){
        //   window.location.reload()
        // }
        // setInterval(function(){
        //   playSound(productOK)
        // },3000)
        setInterval(submitOrder, 200)//扫描条码的输入框
        setInterval(RefreshUncompletedOrdersCount, 2000)//单独更新剩余订单
    });
    function ShowAlertMessage(msg){
        $("#blurAlert").text(msg).show()
    }
    function HideAlertMessage(){
        $("#blurAlert").hide()
    }    
    function prepareBarcodeInput(){
      $("#inputID").focus(function(){
          HideAlertMessage()
        // $("#blurAlert").hide()
      });
      $("#inputID").blur(function(){
        ShowAlertMessage("警告：页面已经失去焦点，扫描的条码失效")
        // $("#blurAlert").show()
      });

      $("#inputID")[0].focus()        
    }    
    function ToUncompltedDetail(){
      window.location.href = "/PickingupOrdersDetailIndex"
    }

    </script>
  </body>
</html>
