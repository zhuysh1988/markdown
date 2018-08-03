# 遇到错误会自动退出
    set -e

+ 你写的每个脚本都应该在文件开头加上set -e,这句语句告诉bash如果任何语句的执行结果不是true则应该退出。
+ 这样的好处是防止错误像滚雪球般变大导致一个致命的错误，而这些错误本应该在之前就被处理掉。
+ 如果要增加可读性，可以使用set -o errexit，它的作用与set -e相同。


# 找出脚本绝对路径:
    SCRIPT=readlink -f "{$0}"
    SCRIPT_DIR=$(dirname "${SCRIPT}")

    # 另一种
    SCRIPT_DIR=$(cd `dirname "${0}"` && pwd)
