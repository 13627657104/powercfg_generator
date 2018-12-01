#!/bin/sh
# powercfg_generator
# by cjybyjk @ coolapk
# License: GPL v3

# utility functions

function init()
{
    source $basepath/config/config.sh
    [ -f $basepath/config/project_pointer ] && prjPtr=$(cat $basepath/config/project_pointer)
    [ -f $basepath/projects/$prjPtr/project_config.sh ] && source $basepath/projects/$prjPtr/project_config.sh
    generatorInfo="powercfg_generator VER:$VER
by cjybyjk @ coolapk
License: GPL v3

当前项目: $project_id
  项目名称：$project_name
  项目作者：$project_author
"
}

function lcase()
{
    echo "$*" | tr '[A-Z]' '[a-z]'
}

# $1:menuText $2:keyList
function showMenu()
{
    [ -z "$1" ] && return 1
    [ -z "$2" ] && return 1
    local menuItems="$1"
    local keyList=($2)
    local selected
    selectedKey=""
    while true
    do
        clear
        echo -e "${generatorInfo}${menuItems}\n"
        read -p "请输入选项: " selected
        selected=$(lcase $selected) 
        for i in ${!keyList[@]}
        do
            if [ "${keyList[$i]}" = "$selected" ]; then
                selectedKey=$selected
                return 0
            fi
        done
    done
    return 0
}

# $1:name $2:value [$3:projectID]
function write_value()
{
    [ -z "$(trim $1)" ] && return 1
    [ -z "$(trim $2)" ] && return 1
    if [ -z "$3" ]; then
        configFile=config/config.sh
    else
        configFile=projects/$3/project_config.sh
    fi
    local tmp=$(grep "^$1=" $configFile)
    if [ -z "$tmp" ]; then
        echo "$1=\"$2\"" >> $configFile
    else
        sed -i "s/^$tmp/$1=\"$2\"/g" $configFile
    fi
    return $?
}

function toggle_boolean()
{
    if [ "true" = "$1" ]; then
        echo "false"
    else
        echo "true"
    fi
}

function pause()
{
    read -n 1 -p "按任意键继续......"
    echo ""
}

function trim()
{
    echo $1 | sed -e 's/^[ \t]*//g' -e 's/[ \t]*$//g'
}

# $1:text $2:default value
function readDefault()
{
    local tmpvalue
    read -p "请输入$1 (留空则使用 $2):  " tmpvalue
    [ -z "$(trim $tmpvalue)" ] && tmpvalue=$2
    echo $tmpvalue
}

# $1:text $2:default(y/n)
function yesNo()
{
    if [ "y" = "$(lcase $2)" ]; then
        read -p "$1 (Y/n) : "
    else
        read -p "$1 (y/N) : "
    fi
    [ "y" = "$(lcase $tmpyn)" ] && return 0
    return 1
 }
 