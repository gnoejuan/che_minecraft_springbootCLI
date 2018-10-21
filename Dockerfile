FROM eclipse/stack-base:ubuntu
EXPOSE 4403 8000 8080 9876 22
LABEL che:server:8080:ref=tomcat8 che:server:8080:protocol=http che:server:8000:ref=tomcat8-debug che:server:8000:protocol=http che:server:9876:ref=codeserver che:server:9876:protocol=http
ENV MAVEN_VERSION=3.5.3 \
    JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64 \
    TOMCAT_HOME=/home/user/tomcat8 \
    TERM=xterm
ENV M2_HOME=/home/user/apache-maven-$MAVEN_VERSION
ENV PATH=$JAVA_HOME/bin:$M2_HOME/bin:$PATH
ENV JAVA_OPTIONS=-Xmx300m
RUN mkdir /home/user/tomcat8 /home/user/apache-maven-$MAVEN_VERSION && \
    wget -qO- "http://apache.ip-connect.vn.ua/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz" | tar -zx --strip-components=1 -C /home/user/apache-maven-$MAVEN_VERSION/ && \
    wget -qO- "http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.24/bin/apache-tomcat-8.0.24.tar.gz" | tar -zx --strip-components=1 -C /home/user/tomcat8 && \
    rm -rf /home/user/tomcat8/webapps/* && \
    echo "export MAVEN_OPTS=\$JAVA_OPTS" >> /home/user/.bashrc && \
    sudo chgrp -R 0 ~/tomcat8 && \
    sudo chmod -R g+rwX ~/tomcat8
RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends zip && \
    curl -s "https://get.sdkman.io" | bash && \ 
    /bin/bash -i -c "source $HOME/.sdkman/bin/sdkman-init.sh && sdk install springboot"
RUN sudo apt-get install screen -y
RUN sudo mkdir /minecraft && \
    sudo chown -R user: /minecraft
RUN cd /minecraft && \
    curl -o BuildTools.jar https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar &&\
#    /bin/bash -i -c "java -jar BuildTools.jar"
# After researching Minecraft in general, I've discovered hosting a build of the spigot jar **might** be in violation of the EULA