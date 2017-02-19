FROM evarga/jenkins-slave

RUN apt-get update && apt-get -y install software-properties-common
RUN add-apt-repository -y ppa:openjdk-r/ppa && apt-get update && apt-get install -y \ 
	wget \
	unzip \
	git \
	openjdk-8-jdk
# TODO: DOES NOT WORK !!!!!!!
ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/"

COPY tmp/gradle-3.3-bin.zip /opt/
RUN mkdir /opt/gradle &&\
	unzip -d /opt/gradle /opt/gradle-3.3-bin.zip &&\
	rm /opt/gradle-3.3-bin.zip
RUN ln -sf /opt/gradle/gradle-3.3/bin/gradle /usr/local/bin/gradle 

USER jenkins

# TODO: DOES NOT WORK
ENV PATH="$PATH:/opt/gradle/gradle-3.3/bin"

USER root



