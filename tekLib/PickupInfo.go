package tekLib

import (
// "bufio"
// "github.com/astaxie/beego/config"
// "encoding/json"
// "errors"
// "fmt"
// "github.com/codegangsta/cli"
// "github.com/tealeg/xlsx"
// "os"
// "strconv"
// "strings"
// "time"
)

type PickupInfo struct {
	Err          string
	RequestID    string
	ExpressmanID string
	StateCode    int
	// Product   *Product
}

var (
	其它错误          int = -1
	成功查找          int = 0
	没有订单与配送员的绑定信息 int = 1
	没有订单需要该商品         = 2
)

func NewPickupInfo(code int, expressmanID, requestID string) *PickupInfo {
	return &PickupInfo{
		Err:          "",
		ExpressmanID: expressmanID,
		RequestID:    requestID,
		StateCode:    code,
	}
}
func NewPickupErrorInfo(code int, requestID, err string) *PickupInfo {
	return &PickupInfo{
		Err:          err,
		ExpressmanID: "",
		RequestID:    requestID,
		StateCode:    code,
	}
}
