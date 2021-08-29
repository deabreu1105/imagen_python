FROM ubuntu
ENV TZ=Europe/Kiev
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
RUN apt-get install -y python
RUN echo 1.0 >> /etc/version && apt-get install -y git \
    && apt-get install -y iputils-ping

## TRABAJANDO CON  WORKDIR ##
RUN mkdir /datos
WORKDIR /datos
RUN touch f1.txt
RUN mkdir /datos1
WORKDIR /datos1
RUN touch f2.txt

## TRABAJANDO CON COPY ##
# cuando finaliza con punto va a guardar en la carpeta del workdir actual
COPY index.html .
# Tambien lo podemos especidicar con rutas absolutas
COPY app.log /datos

## TRABAJANDO CON ADD ##
# Agregamos el directorio docs que esta en local al directorio docs al directorio del workdir en el contenedor
ADD docs docs
# Copiamos todo lo que empiaza por f al directorio datos en el contenedor
ADD f* /datos/
# copia y desempaqueta todos los archivos contenidos en f.tar y los pega al directorio workdir en el contenedor
ADD f.tar .

## TRABAJANDO CON ENV ##
# Creamos dos variables de entorno dir y dir1
ENV dir=/data dir1=/data1
# Corremos el comando mkdir con las variables de entornos para que cree dichos directorios
RUN mkdir $dir && mkdir $dir1

## TRABAJANDO CON ARG ##
# Creamos una variable dir2
# como vemos esta puede ir sin valor pero el valor se le tiene que pasar al iniciar un contenedor
# ARG dir2
# Creamos un directorio con la variable dir2
# RUN mkdir $dir2
# Creamos la variable user la cual vamos a pasar al crear la imagen
# ARG user
# luego la viariable user se guardara en la variable de entorno user_docker
# ENV user_docker $user
# Copiamos elarchivo con el script adduser.sh a la carpeta del contenedor /datos1
# ADD add_user.sh /datos1
# Corremos el script ya copiado en el contenedor con RUN
# RUN /datos1/add_user.sh

## TRABAJANDO CON EXPOSE PARA EXPONER PUERTOS ##
# Instalamos apache2 
RUN apt-get install -y apache2
# Exponemos para que apache escuche por el puerto 80
EXPOSE 80
# Copiamos el archivo con el script entrypoint.sh a la carpeta del contenedor /datos1
ADD entrypoint.sh /datos1


## VOLUME ##
# Anadimos el directorio paginas al contenedor en /var/www/html 
ADD paginas /var/www/html
# Creamos un volumen basado en el directorio /var/www/html
VOLUME ["/var/www/html"]


## CMD ##
# Con CMD ejecutamos el script
# Los comando que significa cambiar de estado por productos, servicios etc no funcionan con RUN
CMD /datos1/entrypoint.sh


# El siguiente comando lo ejecuta en una Shel ==> /bin/sh -c
# CMD echo "welcome to this container"
# El siguiente comando lo ejecuta con exec este es el metodo preferido porque no depende de Shell
# CMD ["echo","welcome to this container"]
# Este comando no seria correcto
# CMD /bin/bash
# El comando anterior se debe hacer de esta manera
# CMD ["/bin/bash"]
# Cambiamos el CMD por ENTRYPOINT
# ENTRYPOINT ["/bin/bash"]

