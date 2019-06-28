## Script de backup

Uma adptação de [bkupscript.sh](https://github.com/mwikya/bash_scripts/blob/eff6a7726ad194d428a24b5bc4647684b3e074f7/data_backup/bkupscript.sh)

#### Etapas realizadas atualmente

1. Escript para backups criado para executar na digitalocean droplet.
2. Realiza dump base de dados mysql
3. Compacta pasta do projeto 
4. Envia usando [s3cmd](https://www.digitalocean.com/docs/spaces/resources/s3cmd/) para digitalocean

#### Próximas etapas

- Remover backups antigos
- Enviar log para slack ou salvar localmente

### Exemplo de uso 

```
$ touch teste.txt
$ s3cmd put teste.txt s3://space_name_send   # usando o s3cmd somente para envio do arquivo único
$ ./bkupscript.sh ~/www/MEU_SITE/ MEU_SPACE/PASTA_BACKUPS/ MEU_PREFIX #usando o bkupscript para envio de pasta e banco de dados
```
Onde:   
- ~/www/MEU_SITE = Diretório onde estão os arquivos para o backup
- MEU_SPACE = Nome do seu space da digitalocean
- PASTA_BACKUPS = Pasta de backups separada dentro do space
- MEU_PREFIX = Será usado na frente do nome dos arquivos como prefixo

### Configuração de crontab para execuções automáticas diárias

Antes de fazer o agendamento na crontab é necessário verificar se o horário está correto no servidor, para isso digite no terminal

```
$ data
//Fri Jun 28 17:09:03 -03 2019
```

Caso a data esteja errada, ajuste a time zone:

```
$ sudo dpkg-reconfigure tzdata
//Current default time zone: 'America/Sao_Paulo'
//Local time is now:      Fri Jun 28 17:08:41 -03 2019.
//Universal Time is now:  Fri Jun 28 20:08:41 UTC 2019.

```

### Configuração crontrab

Com a utlização da cron é possível fazer agendamentos de serviços para serem executados em dias/horários específicos no formato UTC, como no exemplos abaixos:

30 * * * *	Execute um comando a 30 minutos após a hora, a cada hora.    
0 13 * * 1	Execute um comando às 1:00 pm UTC toda segunda-feira.      
*/5 * * * *	Execute um comando a cada cinco minutos.       
0 */2 * * *	Execute um comando a cada segunda hora, na hora.     


Exemplo Para executar o backup **a cada cinco minutos**
```
    */5 * * * * SEU_USUARIO_LINUX ~/bkupscript.sh ~/www/MEU_SITE/ MEU_SPACE/PASTA_BACKUPS/ MEU_PREFIX
```

Exemplo Para executar o backup **todos os dias as 3 da madrugada**
```
    0 03 * * * SEU_USUARIO_LINUX ~/bkupscript.sh ~/www/MEU_SITE/ MEU_SPACE/PASTA_BACKUPS/ MEU_PREFIX
```

Basta adicionar o comando acima no final do arquivo */etc/crontab* e reiniciar a cron que estará configurado:
```
$ sudo chmod +x ~/bkupscript.sh //Permissão no arquivo que será executado.
$ sudo /etc/init.d/cron restart
```


### Links úteis

[s3cmd 2.x Setup](https://www.digitalocean.com/docs/spaces/resources/s3cmd/)   
[s3cmd 2.x Usage](https://www.digitalocean.com/docs/spaces/resources/s3cmd-usage/)   
[Example Code](https://github.com/mwikya/bash_scripts/blob/eff6a7726ad194d428a24b5bc4647684b3e074f7/data_backup/bkupscript.sh)    
[DATA E HORA DO SISTEMA](https://www.vivaolinux.com.br/dica/Data-e-hora-do-sistema)   
[Cron time string format](https://support.acquia.com/hc/en-us/articles/360004224494-Cron-time-string-format)    