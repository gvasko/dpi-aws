FROM evarga/jenkins-slave

RUN apt-get update && apt-get install -y \ 
	wget \
	unzip \
	git

COPY tmp/gradle-3.3-bin.zip /opt/
RUN mkdir /opt/gradle &&\
	unzip -d /opt/gradle /opt/gradle-3.3-bin.zip &&\
	rm /opt/gradle-3.3-bin.zip
RUN ln -sf /opt/gradle/gradle-3.3/bin/gradle /usr/local/bin/gradle 

USER jenkins

# TODO: DOES NOT WORK
ENV PATH="$PATH:/opt/gradle/gradle-3.3/bin"

USER root



