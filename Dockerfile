FROM java:7u65
MAINTAINER thinkJD <thinkJD@thinkjd.de>

# Install Dependencys
RUN apt-get update
RUN apt-get install -y \
	mono-complete \
	unzip \
	wget
RUN	apt-get clean

# download and install default config	
RUN cd /usr/local && \
	wget http://mcmyadmin.com/Downloads/etc.zip && \ 
	unzip etc.zip && \
	rm etc.zip

# add user mcadmin
RUN	useradd mcadmin -m -s /bin/bash

# download and installMcMyAdmin
RUN	cd /home/mcadmin && \
	wget http://mcmyadmin.com/Downloads/MCMA2_glibc26_2.zip && \
	unzip MCMA2_glibc26_2.zip && \
	rm MCMA2_glibc26_2.zip &&  \
	./MCMA2_Linux_x86_64 -nonotice -updateonly 

COPY	start.sh /home/mcadmin/

# set permissions
RUN	chown -R mcadmin:mcadmin /home/mcadmin
RUN	chmod +x /home/mcadmin/start.sh

# expose web ui and default mc server port
EXPOSE	8080
EXPOSE	25565

USER	mcadmin

# you cant call MCMA2 directly
ENTRYPOINT	["/home/mcadmin/start.sh"]
CMD		["-setpass", "mcadmin"]
