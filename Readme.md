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
$ s3cmd put teste.txt s3://space_name_send
```

### Links úteis

[s3cmd 2.x Setup](https://www.digitalocean.com/docs/spaces/resources/s3cmd/)   
[s3cmd 2.x Usage](https://www.digitalocean.com/docs/spaces/resources/s3cmd-usage/)   
[Example Code](https://github.com/mwikya/bash_scripts/blob/eff6a7726ad194d428a24b5bc4647684b3e074f7/data_backup/bkupscript.sh)