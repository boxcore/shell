<?php

/**
 * filesize() 函数在部分 x86 系统上读取大于 2GB 的文件会返回错误的值 
 */


if(empty($argv) || ( count($argv) <= 1)){
    echo "please type file path!\n";
}

array_shift($argv);

foreach($argv as $file){
    // $file = "/Volumes/Edu/sgkII/SGK/Small/黑客库/红黑.mdb";

    echo "=================file info=================\n";
    echo "\n";

    if(!file_exists($file)){
        echo "File don't exist! please check: {$file}\n";
        continue;
    }

    $info = array();

    $info['size'] = filesize($file); // 默认单位Bytes, https://www.bejson.com/convert/filesize/
    $info['md5'] =  md5_file($file);
    $info['mtime'] = filemtime($file); // 上次修改时间
    $info['atime'] = fileatime($file); // 上次被访问时间
    $info['ctime'] = filectime($file); // 文件创建时间

    $info['mtime_d'] = date('Y-m-d H:i:s', $info['mtime']);
    $info['atime_d'] = date('Y-m-d H:i:s', $info['atime']);
    $info['ctime_d'] = date('Y-m-d H:i:s', $info['atime']);


    print_r("文件{$file}信息如下：\n");
    print_r($info);

    echo "------------------------------------\n";
}