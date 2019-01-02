# DonDNS - DonDominio Dynamic IP Client

## 1. Instalar

Para instalar el script debe ponerse en una carpeta y darse permisos de ejecución en caso de que no los tengas (`chmod +x ./dondomcli.sh`)

## 2. Funcionamiento

### IP Automática

De esta forma, se va actualizar la ip de la zona DNS correspondiente a HOST con la  ip de la máquina desde donde se ejecuta el script.  

```
./dondomcli.sh -u DONDOMINIO_USERNAME -p DONDNS_API_KEY -h HOST
```

### Fijar IP

Lo mismo que la anterior, pero la IP no será asignada de forma automática, sino que se asignará la IP especificada por linea de comandos.  

```
./dondomcli.sh -u DONDOMINIO_USERNAME -p DONDNS_API_KEY -h HOST -i IP
```

### Uso del fichero de configuración.

Si no se desea especificar siempre el Usuario y DonDNS Key, se puede asignar a través de un fichero de configuración que se puede llamar de la siguiente manera.  

```
./dondomcli.sh -c FILECONF
```

El resto de opciones pueden especificarse para asignar la misma configuración con diferentes hots.  


```
./dondominio.sh -c FILECONF -h HOST1.DOMINIO.ES
./dondominio.sh -c FILECONF -h HOST2.DOMINIO.COM -i 172.12.1.23
```

El fichero de configuración por defecto es el siguiente:

```
/etc/dondominio/dondomcli.conf
```

## CRON

Para lanzar el script de forma automática, y cada vez que se actualize la dirección IP de un equipo, se debe añadir la siguiente linea en el cron (fichero `/etc/crontab`)  


```
*/5 * * * * user test -x /etc/dondominio/dondomcli.sh && /etc/dondominio/dondomcli.sh -c /etc/dondominio/dondomcli.conf
```
