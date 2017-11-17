Настройка доступа
=================

## Создание Master-пользователя

* На сервере `Docker для production` создать пользователя `master`

    ```
    adduser master
    usermod -aG docker master
    ```

* Зайти под пользователем и создать id_rsa ключ без passphrase

    ```
    ssh-keygen -t rsa -b 4096 -C "master@docker-server-prod.ru"
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
    ```
    
    Этот ключ будет использоваться для SSH-доступа на сервер и для доступа в git-репозитории разработчиков

* В GitLab создать пользователя `master` и добавить ему SSH-ключ

## Создание пользователя-разработчика

* На сервере `Docker для разработки` создать пользователя `dev1` (имя может быть любым)

    ```
    adduser dev1
    usermod -aG docker dev1
    ```
    
* Зайти под пользователем и создать id_rsa ключ без passphrase
    
    ```
    ssh-keygen -t rsa -b 4096 -C "dev1@docker-server-dev.ru"
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
    chmod 400 ~/.ssh/id_rsa ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys 
    ```
        
    Этот ключ будет использоваться для SSH-доступа на сервер

* В GitLab создать пользователя `dev1`, запретив ему создавать свои репозитории и группы
    
    SSH-ключ настраивать не нужно - разработчик сам себе его настроит

* В GitLab создать группу `dev1-projects`
    
    Добавить в группу пользователя `master` с ролью `Master`
    
    В этой группе будут находиться все репозитории разработчика
