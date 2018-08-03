###MySQL 当记录不存在时插入（insert if not exists）

>在 MySQL 中，插入（insert）一条记录很简单，但是一些特殊应用，在插入记录前，需要检查这条记录是否已经存在，只有当记录不存在时才执行插入操作，本文介绍的就是这个问题的解决方案。

>问题：我创建了一个表来存放客户信息，我知道可以用 insert 语句插入信息到表中，但是怎么样才能保证不会插入重复的记录呢？

>答案：可以通过使用 EXISTS 条件句防止插入重复记录。

###示例一：插入多条记录

>假设有一个主键为 client_id 的 clients 表，可以使用下面的语句：


    INSERT INTO clients
    (client_id, client_name, client_type)
    SELECT supplier_id, supplier_name, 'advertising'
    FROM suppliers
    WHERE not exists (select * from clients
    where clients.client_id = suppliers.supplier_id);
###示例一：插入单条记录


    INSERT INTO clients
    (client_id, client_name, client_type)
    SELECT 10345, 'IBM', 'advertising'
    FROM dual
    WHERE not exists (select * from clients
    where clients.client_id = 10345);
###使用 dual 做表名可以让你在 select 语句后面直接跟上要插入字段的值，即使这些值还不存在当前表中。
