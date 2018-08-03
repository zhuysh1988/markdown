##取得项目的 Git 仓库

>有两种取得 Git 项目仓库的方法。第一种是在现存的目录下，通过导入所有文件来创建新的 Git 仓库。第二种是从已有的 Git 仓库克隆出一个新的镜像仓库来。



###在工作目录中初始化新仓库

>要对现有的某个项目开始用 Git 管理，只需到此项目所在的目录，执行:



    $ git init

>初始化后，在当前目录下会出现一个名为 .git 的目录，所有 Git 需要的数据和资源都存放在这个目录中。不过目前，仅仅是按照既有的结构框架初始化好了里边所有的文件和目录，但我们还没有开始跟踪管理项目中的任何一个文件。

>（在第九章我们会详细说明刚才创建的 .git 目录中究竟有哪些文件，以及都起些什么作用。）



>如果当前目录下有几个文件想要纳入版本控制，需要先用 git add 命令告诉 Git 开始对这些文件进行跟踪，然后提交:



    $ git add *.c

    $ git add README

    $ git commit -m 'initial project version'

>稍后我们再逐一解释每条命令的意思。不过现在，你已经得到了一个实际维护着若干文件的 Git 仓库。



###从现有仓库克隆

>如果想对某个开源项目出一份力，可以先把该项目的 Git 仓库复制一份出来，这就需要用到 git clone 命令。

>如果你熟悉其他的 VCS 比如 Subversion，你可能已经注意到这里使用的是 clone 而不是 checkout 。

>这是个非常重要的差别，Git 收取的是项目历史的所有数据（每一个文件的每一个版本），服务器上有的数据克隆之后本地也都有了。

>实际上，即便服务器的磁盘发生故障，用任何一个克隆出来的客户端都可以重建服务器上的仓库，回到当初克隆时的状态（虽然可能会丢失某些服务器端的挂钩设置，但所有版本的数据仍旧还在，有关细节请参考第四章）。



####克隆仓库的命令格式为 git clone [url] 。比如，要克隆 Ruby 语言的 Git 代码仓库 Grit，可以用下面的命令:



    $ git clone git://github.com/schacon/grit.git

>这会在当前目录下创建一个名为 “grit” 的目录，其中包含一个 .git 的目录，用于保存下载下来的所有版本记录，然后从中取出最新版本的文件拷贝。

>如果进入这个新建的 grit 目录，你会看到项目中的所有文件已经在里边了，准备好后续的开发和使用。如果希望在克隆的时候，自己定义要新建的项目目录名称，可以在上面的命令末尾指定新的名字:



    $ git clone git://github.com/schacon/grit.git mygrit

>唯一的差别就是，现在新建的目录成了 mygrit，其他的都和上边的一样。



>Git 支持许多数据传输协议。之前的例子使用的是 git:// 协议，不过你也可以用 http(s):// 或者 user@server:/path.git 表示的 SSH 传输协议。

>我们会在第四章详细介绍所有这些协议在服务器端该如何配置使用，以及各种方式之间的利弊。





###记录每次更新到仓库

>现在我们手上已经有了一个真实项目的 Git 仓库，并从这个仓库中取出了所有文件的工作拷贝。接下来，对这些文件作些修改，在完成了一个阶段的目标之后，提交本次更新到仓库。

>

>请记住，工作目录下面的所有文件都不外乎这两种状态：已跟踪或未跟踪。已跟踪的文件是指本来就被纳入版本控制管理的文件，在上次快照中有它们的记录，工作一段时间后，它们的状态可能是未更新，已修改或者已放入暂存区。

>而所有其他文件都属于未跟踪文件。它们既没有上次更新时的快照，也不在当前的暂存区域。初次克隆某个仓库时，工作目录中的所有文件都属于已跟踪文件，且状态为未修改。





###检查当前文件状态

>要确定哪些文件当前处于什么状态，可以用 git status 命令。如果在克隆仓库之后立即执行此命令，会看到类似这样的输出:



    $ git status

    # On branch master

    nothing to commit (working directory clean)

>这说明你现在的工作目录相当干净。换句话说，当前没有任何跟踪着的文件，也没有任何文件在上次提交后更改过。

>此外，上面的信息还表明，当前目录下没有出现任何处于未跟踪的新文件，否则 Git 会在这里列出来。最后，该命令还显示了当前所在的分支是 master，这是默认的分支名称，实际是可以修改的，现在先不用考虑。

>下一章我们就会详细讨论分支和引用。

>

>现在让我们用 vim 编辑一个新文件 README，保存退出后运行 git status 会看到该文件出现在未跟踪文件列表中:

>

    $ vim README

    $ git status

    # On branch master

    # Untracked files:

    #   (use "git add <file>..." to include in what will be committed)

    #

    #   README

    nothing added to commit but untracked files present (use "git add" to track)

>就是在 “Untracked files” 这行下面。Git 不会自动将之纳入跟踪范围，除非你明明白白地告诉它“我需要跟踪该文件”，因而不用担心把临时文件什么的也归入版本管理。不过现在的例子中，我们确实想要跟踪管理 README 这个文件。



###跟踪新文件

>使用命令 git add 开始跟踪一个新文件。所以，要跟踪 README 文件，运行:



    $ git add README

>此时再运行 git status 命令，会看到 README 文件已被跟踪，并处于暂存状态:



    $ git status

    # On branch master

    # Changes to be committed:

    #   (use "git reset HEAD <file>..." to unstage)

    #

    #   new file:   README

    #

>只要在 “Changes to be committed” 这行下面的，就说明是已暂存状态。如果此时提交，那么该文件此时此刻的版本将被留存在历史记录中。

>你可能会想起之前我们使用 git init 后就运行了 git add 命令，开始跟踪当前目录下的文件。在 git add 后面可以指明要跟踪的文件或目录路径。

>如果是目录的话，就说明要递归跟踪该目录下的所有文件。

>（译注：其实 git add 的潜台词就是把目标文件快照放入暂存区域，也就是 add file into staged area ，同时未曾跟踪过的文件标记为需要跟踪。这样就好理解后续 add 操作的实际意义了。）



###暂存已修改文件

>现在我们修改下之前已跟踪过的文件 benchmarks.rb ，然后再次运行 status 命令，会看到这样的状态报告:



    $ git status

    # On branch master

    # Changes to be committed:

    #   (use "git reset HEAD <file>..." to unstage)

    #

    #   new file:   README

    #

    # Changes not staged for commit:

    #   (use "git add <file>..." to update what will be committed)

    #

    #   modified:   benchmarks.rb

    #

######文件 benchmarks.rb 出现在 “Changes not staged for commit” 这行下面，说明已跟踪文件的内容发生了变化，但还没有放到暂存区。

######要暂存这次更新，需要运行 git add 命令（这是个多功能命令，根据目标文件的状态不同，此命令的效果也不同：可以用它开始跟踪新文件，或者把已跟踪的文件放到暂存区，还能用于合并时把有冲突的文件标记为已解决状态等）。

######现在让我们运行 git add 将 benchmarks.rb 放到暂存区，然后再看看 git status 的输出:



    $ git add benchmarks.rb

    $ git status

    # On branch master

    # Changes to be committed:

    #   (use "git reset HEAD <file>..." to unstage)

    #

    #   new file:   README

    #   modified:   benchmarks.rb

    #

>现在两个文件都已暂存，下次提交时就会一并记录到仓库。假设此时，你想要在 benchmarks.rb 里再加条注释，重新编辑存盘后，准备好提交。不过且慢，再运行 git status 看看:



    $ vim benchmarks.rb

    $ git status

    # On branch master

    # Changes to be committed:

    #   (use "git reset HEAD <file>..." to unstage)

    #

    #   new file:   README

    #   modified:   benchmarks.rb

    #

    # Changes not staged for commit:

    #   (use "git add <file>..." to update what will be committed)

    #

    #   modified:   benchmarks.rb

    #

>怎么回事？ benchmarks.rb 文件出现了两次！一次算未暂存，一次算已暂存，这怎么可能呢？

>好吧，实际上 Git 只不过暂存了你运行 git add 命令时的版本，如果现在提交，那么提交的是添加注释前的版本，而非当前工作目录中的版本。

>所以，运行了 git add 之后又作了修订的文件，需要重新运行 git add 把最新版本重新暂存起来:



    $ git add benchmarks.rb

    $ git status

    # On branch master

    # Changes to be committed:

    #   (use "git reset HEAD <file>..." to unstage)

    #

    #   new file:   README

    #   modified:   benchmarks.rb

    #

###忽略某些文件

>一般我们总会有些文件无需纳入 Git 的管理，也不希望它们总出现在未跟踪文件列表。

>通常都是些自动生成的文件，比如日志文件，或者编译过程中创建的临时文件等。

>我们可以创建一个名为 .gitignore 的文件，列出要忽略的文件模式。来看一个实际的例子:



    $ cat .gitignore

    *.[oa]

    *~

>第一行告诉 Git 忽略所有以 .o 或 .a 结尾的文件。一般这类对象文件和存档文件都是编译过程中出现的，我们用不着跟踪它们的版本。

>第二行告诉 Git 忽略所有以波浪符（~）结尾的文件，许多文本编辑软件（比如 Emacs）都用这样的文件名保存副本。

>此外，你可能还需要忽略 log，tmp 或者 pid 目录，以及自动生成的文档等等。要养成一开始就设置好 .gitignore 文件的习惯，以免将来误提交这类无用的文件。



##文件 .gitignore 的格式规范如下：



    所有空行或者以注释符号 ＃ 开头的行都会被 Git 忽略。

    可以使用标准的 glob 模式匹配。

    匹配模式最后跟反斜杠（/）说明要忽略的是目录。

    要忽略指定模式以外的文件或目录，可以在模式前加上惊叹号（!）取反。

    所谓的 glob 模式是指 shell 所使用的简化了的正则表达式。星号（*）匹配零个或多个任意字符；

    [abc] 匹配任何一个列在方括号中的字符（这个例子要么匹配一个 a，要么匹配一个 b，要么匹配一个 c）；

    问号（?）只匹配一个任意字符；如果在方括号中使用短划线分隔两个字符，表示所有在这两个字符范围内的都可以匹配（比如 [0-9] 表示匹配所有 0 到 9 的数字）。



>我们再看一个 .gitignore 文件的例子:



    # 此为注释 – 将被 Git 忽略

    *.a       # 忽略所有 .a 结尾的文件

    !lib.a    # 但 lib.a 除外

    /TODO     # 仅仅忽略项目根目录下的 TODO 文件，不包括 subdir/TODO

    build/    # 忽略 build/ 目录下的所有文件

    doc/*.txt # 会忽略 doc/notes.txt 但不包括 doc/server/arch.txt

###查看已暂存和未暂存的更新

>实际上 git status 的显示比较简单，仅仅是列出了修改过的文件，如果要查看具体修改了什么地方，可以用 git diff 命令。

>稍后我们会详细介绍 git diff，不过现在，它已经能回答我们的两个问题了：当前做的哪些更新还没有暂存？有哪些更新已经暂存起来准备好了下次提交？ 

>git diff 会使用文件补丁的格式显示具体添加和删除的行。



>假如再次修改 README 文件后暂存，然后编辑 benchmarks.rb 文件后先别暂存，运行 status 命令，会看到:



    $ git status

    # On branch master

    # Changes to be committed:

    #   (use "git reset HEAD <file>..." to unstage)

    #

    #   new file:   README

    #

    # Changes not staged for commit:

    #   (use "git add <file>..." to update what will be committed)

    #

    #   modified:   benchmarks.rb

    #

>要查看尚未暂存的文件更新了哪些部分，不加参数直接输入 git diff:



    $ git diff

    diff --git a/benchmarks.rb b/benchmarks.rb

    index 3cb747f..da65585 100644

    --- a/benchmarks.rb

    +++ b/benchmarks.rb

    @@ -36,6 +36,10 @@ def main

               @commit.parents[0].parents[0].parents[0]

             end

    

    +        run_code(x, 'commits 1') do

    +          git.commits.size

    +        end

    +

             run_code(x, 'commits 2') do

               log = git.commits('master', 15)

               log.size

>此命令比较的是工作目录中当前文件和暂存区域快照之间的差异，也就是修改之后还没有暂存起来的变化内容。



>若要看已经暂存起来的文件和上次提交时的快照之间的差异，可以用 git diff –cached 命令。

>（Git 1.6.1 及更高版本还允许使用 git diff –staged ，效果是相同的，但更好记些。）来看看实际的效果:



    $ git diff --cached

    diff --git a/README b/README

    new file mode 100644

    index 0000000..03902a1

    --- /dev/null

    +++ b/README2

    @@ -0,0 +1,5 @@

    +grit

    + by Tom Preston-Werner, Chris Wanstrath

    + http://github.com/mojombo/grit

    +

    +Grit is a Ruby library for extracting information from a Git repository

>请注意，单单 git diff 不过是显示还没有暂存起来的改动，而不是这次工作和上次提交之间的差异。所以有时候你一下子暂存了所有更新过的文件后，运行 git diff 后却什么也没有，就是这个原因。

>

>像之前说的，暂存 benchmarks.rb 后再编辑，运行 git status 会看到暂存前后的两个版本:



    $ git add benchmarks.rb

    $ echo '# test line' >> benchmarks.rb

    $ git status

    # On branch master

    #

    # Changes to be committed:

    #

    #   modified:   benchmarks.rb

    #

    # Changes not staged for commit:

    #

    #   modified:   benchmarks.rb

    #

>现在运行 git diff 看暂存前后的变化:



    $ git diff

    diff --git a/benchmarks.rb b/benchmarks.rb

    index e445e28..86b2f7c 100644

    --- a/benchmarks.rb

    +++ b/benchmarks.rb

    @@ -127,3 +127,4 @@ end

     main()

    

     ##pp Grit::GitRuby.cache_client.stats

    +# test line

>然后用 git diff –cached 查看已经暂存起来的变化:

>

    $ git diff --cached

    diff --git a/benchmarks.rb b/benchmarks.rb

    index 3cb747f..e445e28 100644

    --- a/benchmarks.rb

    +++ b/benchmarks.rb

    @@ -36,6 +36,10 @@ def main

              @commit.parents[0].parents[0].parents[0]

            end

    

    +        run_code(x, 'commits 1') do

    +          git.commits.size

    +        end

    +

            run_code(x, 'commits 2') do

              log = git.commits('master', 15)

              log.size

###提交更新

>现在的暂存区域已经准备妥当可以提交了。在此之前，请一定要确认还有什么修改过的或新建的文件还没有 git add 过，否则提交的时候不会记录这些还没暂存起来的变化。

>所以，每次准备提交前，先用 git status 看下，是不是都已暂存起来了，然后再运行提交命令 git commit



    $ git commit

>这种方式会启动文本编辑器以便输入本次提交的说明。

>（默认会启用 shell 的环境变量 $EDITOR 所指定的软件，一般都是 vim 或 emacs。当然也可以按照第一章介绍的方式，使用 git config –global core.editor 命令设定你喜欢的编辑软件。）



>编辑器会显示类似下面的文本信息（本例选用 Vim 的屏显方式展示）:



    # Please enter the commit message for your changes. Lines starting

    # with '#' will be ignored, and an empty message aborts the commit.

    # On branch master

    # Changes to be committed:

    #   (use "git reset HEAD <file>..." to unstage)

    #

    #       new file:   README

    #       modified:   benchmarks.rb

    ~

    ~

    ~

    ".git/COMMIT_EDITMSG" 10L, 283C

>可以看到，默认的提交消息包含最后一次运行 git status 的输出，放在注释行里，另外开头还有一空行，供你输入提交说明。

>你完全可以去掉这些注释行，不过留着也没关系，多少能帮你回想起这次更新的内容有哪些。（如果觉得这还不够，可以用 -v 选项将修改差异的每一行都包含到注释中来。）

>退出编辑器时，Git 会丢掉注释行，将说明内容和本次更新提交到仓库。



>另外也可以用 -m 参数后跟提交说明的方式，在一行命令中提交更新:



    $ git commit -m "Story 182: Fix benchmarks for speed"

    [master]: created 463dc4f: "Fix benchmarks for speed"

     2 files changed, 3 insertions(+), 0 deletions(-)

     create mode 100644 README

>好，现在你已经创建了第一个提交！可以看到，提交后它会告诉你，当前是在哪个分支（master）提交的，本次提交的完整 SHA-1 校验和是什么（463dc4f），以及在本次提交中，有多少文件修订过，多少行添改和删改过。



>记住，提交时记录的是放在暂存区域的快照，任何还未暂存的仍然保持已修改状态，可以在下次提交时纳入版本管理。每一次运行提交操作，都是对你项目作一次快照，以后可以回到这个状态，或者进行比较。



###跳过使用暂存区域

>尽管使用暂存区域的方式可以精心准备要提交的细节，但有时候这么做略显繁琐。

Git 提供了一个跳过使用暂存区域的方式，只要在提交的时候，给 git commit 加上 -a 选项，

Git 就会自动把所有已经跟踪过的文件暂存起来一并提交，从而跳过 git add 步骤:



    $ git status

    # On branch master

    #

    # Changes not staged for commit:

    #

    #   modified:   benchmarks.rb

    #

    $ git commit -a -m 'added new benchmarks'

    [master 83e38c7] added new benchmarks

     1 files changed, 5 insertions(+), 0 deletions(-)

>看到了吗？提交之前不再需要 git add 文件 benchmarks.rb 了。



###移除文件

>要从 Git 中移除某个文件，就必须要从已跟踪文件清单中移除（确切地说，是从暂存区域移除），然后提交。可以用 git rm 命令完成此项工作，并连带从工作目录中删除指定的文件，这样以后就不会出现在未跟踪文件清单中了。

>

>如果只是简单地从工作目录中手工删除文件，运行 git status 时就会在 “Changes not staged for commit” 部分（也就是未暂存清单）看到:



    $ rm grit.gemspec

    $ git status

    # On branch master

    #

    # Changes not staged for commit:

    #   (use "git add/rm <file>..." to update what will be committed)

    #

    #       deleted:    grit.gemspec

    #

>然后再运行 git rm 记录此次移除文件的操作:



    $ git rm grit.gemspec

    rm 'grit.gemspec'

    $ git status

    # On branch master

    #

    # Changes to be committed:

    #   (use "git reset HEAD <file>..." to unstage)

    #

    #       deleted:    grit.gemspec

    #

>最后提交的时候，该文件就不再纳入版本管理了。如果删除之前修改过并且已经放到暂存区域的话，则必须要用强制删除选项 -f（译注：即 force 的首字母），以防误删除文件后丢失修改的内容。

>

>另外一种情况是，我们想把文件从 Git 仓库中删除（亦即从暂存区域移除），但仍然希望保留在当前工作目录中。换句话说，仅是从跟踪清单中删除。比如一些大型日志文件或者一堆 .a 编译文件，不小心纳入仓库后，要移除跟踪但不删除文件，以便稍后在 .gitignore 文件中补上，用 –cached 选项即可:



     git rm --cached readme.txt

>后面可以列出文件或者目录的名字，也可以使用 glob 模式。比方说:



     git rm log/\*.log

>注意到星号 * 之前的反斜杠 ，因为 Git 有它自己的文件模式扩展匹配方式，所以我们不用 shell 来帮忙展开（译注：实际上不加反斜杠也可以运行，只不过按照 shell 扩展的话，仅仅删除指定目录下的文件而不会递归匹配。上面的例子本来就指定了目录，所以效果等同，但下面的例子就会用递归方式匹配，所以必须加反斜杠。）。此命令删除所有 log/ 目录下扩展名为 .log 的文件。类似的比如：



     git rm *~

>会递归删除当前目录及其子目录中所有 ~ 结尾的文件。



##移动文件

>不像其他的 VCS 系统，Git 并不跟踪文件移动操作。如果在 Git 中重命名了某个文件，仓库中存储的元数据并不会体现出这是一次改名操作。不过 Git 非常聪明，它会推断出究竟发生了什么，至于具体是如何做到的，我们稍后再谈。

>

>既然如此，当你看到 Git 的 mv 命令时一定会困惑不已。要在 Git 中对文件改名，可以这么做:



     git mv file_from file_to

>它会恰如预期般正常工作。实际上，即便此时查看状态信息，也会明白无误地看到关于重命名操作的说明:



     git mv README.txt README

     git status

    # On branch master

    # Your branch is ahead of 'origin/master' by 1 commit.

    #

    # Changes to be committed:

    #   (use "git reset HEAD <file>..." to unstage)

    #

    #       renamed:    README.txt -> README

    #

>其实，运行 git mv 就相当于运行了下面三条命令:



     mv README.txt README

     git rm README.txt

     git add README

>如此分开操作，Git 也会意识到这是一次改名，所以不管何种方式都一样。当然，直接用 git mv 轻便得多，不过有时候用其他工具批处理改名的话，要记得在提交前删除老的文件名，再添加新的文件名。
