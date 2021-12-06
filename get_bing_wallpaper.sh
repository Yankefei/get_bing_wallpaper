#!/bin/bash

#cd /c/Users/cool/Desktop/daily_scheduled_tashs
log_file_name=log_"`date +%Y-%m`.log"
date_str="`date +%Y-%m-%d`"

file_1200_dir="bing_1920_1200"
file_1080_dir="bing_1920_1080"


cur_date="`date +%m%d`"


ErrorLog()
{
    echo "${date_str}_`date +%H:%M:%S` Error: $1" >> ${log_file_name}
}

InfoLog()
{
    echo "${date_str}_`date +%H:%M:%S` Info:  $1" >> ${log_file_name}
}

CleanFile()
{
    if [ -f $1 ]; then
        rm -f $1
    fi   
}
    
GetWrapperFile()
{
    InfoLog "crul_wrapper_req: $1"
    wrapper_file_name=${cur_date}"_$2 $3.jpg"
    wrapper_file_name_back=${cur_date}"_$2.jpg"

    #无需替换文件名中的空格
    #wrapper_file_name=$(echo ${wrapper_file_name} | sed 's/ /_/g')
    #wrapper_file_name_back=$(echo ${wrapper_file_name_back} | sed 's/ /_/g')

    curl $1 >>  temp_wrapper_file

    # 避免文件名中存在空格
    mv temp_wrapper_file  "$4/${wrapper_file_name}"  >> /dev/null 2>&1

    #mv 创建的文件名过长，则会失败，所以这里多半会失败。只能退而使用备份的文件名
    if [ $? -ne 0 ]; then
        ErrorLog "mv to ideal_file_name: ${wrapper_file_name}"
        mv temp_wrapper_file  "$4/${wrapper_file_name_back}"

        #如果仍然失败，则仅仅用日期来作为文件名
        if [ $? -ne 0 ]; then
            ErrorLog "mv to back_file_name:${wrapper_file_name_back}"
            mv temp_wrapper_file  "$4/${cur_date}.jpg"
            InfoLog "mv to date_file_name: ${wrapper_file_name}"
        else
            InfoLog "mv to ideal_file_name: ${wrapper_file_name_back}"
        fi
    else
        InfoLog "mv to ideal_file_name: ${wrapper_file_name}"
    fi

    CleanFile temp_wrapper_file
}


InfoLog "Begin"

html_file=html_"`date +%Y-%m-%d`".html

curl  https://cn.bing.com >> ${html_file}

#获取到包含背景图片url和名称等相关区域的信息
html_content=$(cat ${html_file} |grep -i "\"Wallpaper\":\""  | awk -F Wallpaper\"\:\" '{print $2}'  |awk -F  \",\"SocialGood  '{print $1}')
#如果想输出包含空格的内容，需要增加""符号
InfoLog "${html_content}"

#${html_content} example:
#/th?id=OHR.MistyTor_ZH-CN7520952555_1920x1200.jpg\u0026rf=LaDigue_1920x1200.jpg","Downloadable":true},"Headline":null,"Title":"Glastonbury Tor, Somerset, England","Copyright":"© DEEPOL by plainpicture/Adam Burton
#按照如上的示例，过滤出图片url, 图片名称，图片版权等信息
curl_wrapper_req="https://cn.bing.com"$(echo ${html_content} |awk -F .jpg '{print $1}')".jpg"

title_content=$(echo ${html_content} |awk -F Title\":\" '{print $2}' |awk  -F \",\"Copyright '{print $1}')

copy_right=$(echo ${html_content} |awk  -F Copyright\":\"©  '{print $2}')


InfoLog "${title_content}"
InfoLog "${copy_right}"

#如果参数使用''而不是"", 则内部的变量无法被正确解析
InfoLog "read to get 1920* 1200 file: ${file_1200_dir}"
GetWrapperFile "${curl_wrapper_req}" "${title_content}"  "${copy_right}"  "${file_1200_dir}"

# 更新url的内容
curl_wrapper_req_1080=$(echo ${curl_wrapper_req} | sed 's/1200/1080/g')

InfoLog "read to get 1920* 1080 file: ${file_1080_dir}"
GetWrapperFile "${curl_wrapper_req_1080}" "${title_content}"  "${copy_right}"  "${file_1080_dir}"

#清理html文件
CleanFile "$html_file"

InfoLog "End"

exit 0
