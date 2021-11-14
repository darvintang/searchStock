## Apple直营店库存查询脚本

### 用法一

```shell
# 打开终端
git clone https://github.com/darvintang/searchStock.git 
cd searchStock
sh ./searchStock.sh
# 根据提示输入相关信息
# 请不要关闭窗口，如果关闭窗口就结束
```

### 用法二

```shell
# 通过浏览器下载该仓库
# 解压到桌面
# 打开终端
# 把文件夹的searchStock.sh文件拖到终端
# 在searchStock.sh文件路径之前敲入`sh `
# 执行
```



# 注

> 目前脚本仅支持了2021款的macbookpro，如果需要查询其它设备请自行去查找设备的型号，然后编辑脚本中的modelDict和nameDict字典。字典的key只能用纯数字。
>
> 内置设备型号：
>
> nameDict=([1411]='14寸灰色8核+14核+16G+512G' [1412]='14寸银色8核+14核+16G+512G' [1421]='14寸灰色10核+16核+16G+1T' [1422]='14寸银色10核+16核+16G+1T' [1611]='16寸灰色10核+16核+16G+512G' [1612]='16寸银色10核+16核+16G+512G' [1621]='16寸灰色10核+16核+16G+1T' [1622]='16寸银色10核+16核+16G+1T' [1631]='16寸灰色10核+32核+32G+1T' [1632]='16寸银色10核+32核+32G+1T')
>
> modelDict=([1411]='MKGP3CH/A' [1412]='MKGR3CH/A' [1421]='MKGQ3CH/A' [1422]='MKGT3CH/A' [1611]='MK183CH/A' [1612]='MK1E3CH/A' [1621]='MK193CH/A' [1622]='MK1F3CH/A' [1631]='MK1A3CH/A' [1632]='MK1H3CH/A')
>
> 
