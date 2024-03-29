#W_DIR=$HOME
#W_DIR=/usr/local
S_DIR=$W_DIR/splicious
DOC=0
if [ 0 -eq $DOC ]; then
#  if [ ! -f "$HOME/m2cup-jlex-configgy-prolog-pickling.tar.gz" ]; then 
  if [ ! -d "$HOME/.m2/repository/net/lag/configgy" ]; then 
    wget https://github.com/n10n/DockerNode/raw/master/m2cup-jlex-configgy-prolog-pickling.tar.gz -O $HOME/m2cup-jlex-configgy-prolog-pickling.tar.gz
    cd $HOME ; tar -xzvf m2cup-jlex-configgy-prolog-pickling.tar.gz; rm -f $HOME/m2cup-jlex-configgy-prolog-pickling.tar.gz
  fi 
#  if [ ! -f "$HOME/m2scalaz210700.tar.gz" ]; then
  if [ ! -d "$HOME/.m2/repository/org/scalaz/scalaz-core_2.10" ]; then
    wget https://github.com/n10n/DockerNode/raw/master/m2scalaz210700.tar.gz -O $HOME/m2scalaz210700.tar.gz
    cd $HOME ; tar -xzvf m2scalaz210700.tar.gz; rm -f $HOME/m2scalaz210700.tar.gz
  fi 
fi
  \
  mkdir -p $S_DIR/lib $S_DIR/libui $S_DIR/logs $S_DIR/config && \
  \
## engine    
  cd $W_DIR && \
  if [ ! -d "frontuic" ]; then
    git clone -b synereo https://github.com/LivelyGig/ProductWebUI.git frontuic 
  else 
    cd $W_DIR/frontuic ; git pull 
  fi
  cd $W_DIR && \
  if [ ! -d "SpecialK" ]; then
    git clone -b 1.0 https://github.com/synereo/specialk.git SpecialK 
  else
    cd $W_DIR/SpecialK; git pull
  fi
  cd $W_DIR && \
  if [ ! -d "agent-service-ati-ia" ]; then
    git clone -b 1.0 https://github.com/synereo/agent-service-ati-ia.git 
  else
    cd $W_DIR/agent-service-ati-ia; git pull 
  fi
  cd $W_DIR && \
  if [ ! -d "GLoSEval" ]; then
    git clone -b 1.0 https://github.com/synereo/gloseval.git GLoSEval 
  else
    cd $W_DIR/GLoSEval; git pull 
  fi
  \
  cd $W_DIR/SpecialK && \
  mvn -e -fn -Dmaven.test.skip=true -DskipTests=true install prepare-package && \
  cd $W_DIR/agent-service-ati-ia/AgentServices-Store && \
  mvn -e -fn -Dmaven.test.skip=true -DskipTests=true install prepare-package && \
  cd $W_DIR/GLoSEval && \
  mvn -e -fn -Dmaven.test.skip=true -DskipTests=true install prepare-package && \
  \
  cp -rp $W_DIR/SpecialK/target/lib/* $S_DIR/lib/ && \
  cp -rp $W_DIR/agent-service-ati-ia/AgentServices-Store/target/lib/* $S_DIR/lib/ && \
  cp -rp $W_DIR/GLoSEval/target/lib/* $S_DIR/lib/ && \
  cp -rp $W_DIR/GLoSEval/target/gloseval-0.1.jar $S_DIR/lib/ && \
  \
  cp $W_DIR/GLoSEval/eval.conf $S_DIR/config/ && \
  cp -rp $W_DIR/GLoSEval/scripts $S_DIR/ && \
  cd $S_DIR && \
  ln -fs config/eval.conf eval.conf && \
  cp $W_DIR/GLoSEval/log.properties $S_DIR/ && \
  \
  rm -rf /var/cache/apk/* && \
  rm -f $S_DIR/lib/junit-3.8.1.jar $S_DIR/lib/junit-4.7.jar && \
  rm -f $S_DIR/lib/scalaz-core_2.10-6.0.4.jar $S_DIR/lib/slf4j-api-1.6.1.jar && \
  rm -f $S_DIR/lib/*.pom && \
  rm -f $S_DIR/bin/._* && \
  \
## New UI
  cd $W_DIR/frontuic && \
# sbt -java-home /usr/lib/jvm/java-1.8-openjdk -verbose -J-Xmx2G -Dconfig.trace=loads stage && \  
#  sbt -java-home /usr/local/jdk1.8.0_77 -verbose -J-Xmx2G -Dconfig.trace=loads stage && \
  sbt -verbose -J-Xmx3G -Dconfig.trace=loads stage && \
  cp -fp $W_DIR/frontuic/server/target/universal/stage/conf/application.conf $S_DIR/config/ui.conf && \
  cd $S_DIR; ln -fs config/ui.conf ui.conf && \
  cp -rfp $W_DIR/frontuic/server/target/universal/stage/lib/* $S_DIR/libui/ && \
  cd $W_DIR/ && \
  \
  if [ 0 -eq $DOC ]; then
    if [ ! -d "$S_DIR/agentui" ]; then
      wget https://github.com/n10n/DockerNode/raw/master/agentui.tar.gz -O $S_DIR/agentui.tar.gz
      tar -xzvf $S_DIR/agentui.tar.gz -C $S_DIR; rm -f agentui.tar.gz
    fi 
    if [ ! -f "$S_DIR/bin/scala" ]; then
      wget https://github.com/n10n/DockerNode/raw/master/scalabin.tar.gz -O $S_DIR/scalabin.tar.gz
      tar -xzvf $S_DIR/scalabin.tar.gz -C $S_DIR; rm -f scalabin.tar.gz
    fi 
    if [ ! -f "$S_DIR/bin/splicious" ]; then
      wget https://github.com/n10n/DockerNode/raw/master/splicious.sh -O $S_DIR/bin/splicious
    fi 
    if [ ! -f "$S_DIR/bin/frontui" ]; then
      wget https://github.com/n10n/DockerNode/raw/master/frontui.sh -O $S_DIR/bin/frontui
    fi 
  fi
  
if [ ! -d $S_DIR/scripts ]; then
  svn checkout --force https://github.com/synereo/gloseval/branches/1.0/scripts 
  rm -rf $S_DIR/scripts/.svn 
  svn checkout --force https://github.com/synereo/agent-service-ati-ia/branches/1.0/AgentServices-Store/scripts 
  rm -rf $S_DIR/scripts/.svn 
  svn checkout --force https://github.com/synereo/specialk/trunk/scripts 
  rm -rf $S_DIR/scripts/.svn
fi   

  cd $W_DIR/ && \
  chmod 755 $S_DIR/bin/* $S_DIR/bin/* 

## reduce size
#  rm -rf $W_DIR/GLoSEval/target && \
#  rm -rf $W_DIR/GLoSEval/project/target && \
#  rm -rf $W_DIR/SpecialK/target && \
#  rm -rf $W_DIR/agent-service-ati-ia/target && \
#  rm -rf $W_DIR/agent-service-ati-ia/AgentServices-Store/target && \
#  rm -rf $W_DIR/frontuic/target  && \
#  rm -rf $W_DIR/frontuic/sclient/target && \
#  rm -rf $W_DIR/frontuic/shared/.js/target && \
#  rm -rf $W_DIR/frontuic/shared/.jvm/target && \
#  rm -rf $W_DIR/frontuic/project/target && \
#  rm -rf $W_DIR/frontuic/project/project/target && \
#  rm -rf $W_DIR/frontuic/server/target && \
#  rm -rf $HOME/.m2 $HOME/.sbt $HOME/.ivy2 $HOME/.zinc && \
echo " deployer is exiting.......$?"
exit $?
