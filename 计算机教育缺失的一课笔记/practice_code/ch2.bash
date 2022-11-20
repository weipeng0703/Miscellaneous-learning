###
 # @Descripttion: 
 # @version: 1.0
 # @Author: weipeng
 # @Date: 2022-11-20 15:04:11
 # @LastEditors: weipeng
 # @LastEditTime: 2022-11-20 15:32:35
### 
# 2-编写bash函数
# 编写两个bash函数 marco 和 polo 执行下面的操作。 
# 每当你执行 marco 时，当前的工作目录应当以某种形式保存，
# 当执行 polo 时，无论现在处在什么目录下，都应当 cd 回到当时执行 marco 的目录。 
#!/bin/bash
marco(){
echo "$(pwd)" > $HOME/marco_history.log
echo "save pwd $(pwd)"
}
polo(){
cd "$(cat "$HOME/marco_history.log")"
}
# 或
marco() {
    export MARCO = $(pwd)
}
polo() {
    cd "$MARCO"
}

# 3
# 假设您有一个命令，它很少出错。因此为了在出错时能够对其进行调试，需要花费大量的时间重现错误并捕获输出。 
# 编写一段bash脚本，运行如下的脚本直到它出错，将它的标准输出和标准错误流记录到文件，并在最后输出所有内容。 
# 加分项：报告脚本在失败前共运行了多少次。

#!/usr/bin/env bash

n=$(( RANDOM % 100 ))

if [[ n -eq 42 ]]; then
    echo "Something went wrong"
    >&2 echo "The error was using magic numbers"
    exit 1
fi

echo "Everything went according to plan"

# 使用while循环完成
count=1

while true
do
    ./buggy.sh 2> out.log
    if [[ $? -ne 0 ]]; then
        echo "failed after $count times"
        cat out.log
        break
    fi
    ((count++))

done


# 使用for循环完成
for ((count=1;;count++))
do
    ./buggy.sh 2> out.log
    if [[ $? -ne 0 ]]; then
        echo "failed after $count times"
        cat out.log
        break

    echo "$count try"
    fi
done

# 使用until完成
#!/usr/bin/env bash
count=0
until [[ "$?" -ne 0 ]];
do
    count=$((count+1))
    ./random.sh 2> out.txt
done

echo "found error after $count runs"
cat out.txt

# 5
# 编写一个命令或脚本递归的查找文件夹中最近使用的文件。更通用的做法，你可以按照最近的使用时间列出文件吗？ 
find . -type f -print0 | xargs -0 ls -lt | head -1

# 当文件数量较多时，上面的解答会得出错误结果，解决办法是增加 -mmin 条件，先将最近修改的文件进行初步筛选再交给ls进行排序显示
find . -type f -mmin -60 -print0 | xargs -0 ls -lt | head -10