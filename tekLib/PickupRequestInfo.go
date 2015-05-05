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

type PickupRequestInfo struct {
	chanCallback chan *PickupInfo
	ID           string
}
