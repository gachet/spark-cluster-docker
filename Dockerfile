FROM gliderlabs/alpine:3.6
# Ensure the freshest base image, update the RPM content associated with the base image. This reduces the exposed attack surface
RUN apk --update add --no-cache  \
# https://stackoverflow.com/questions/44576787/apache-spark-startup-error-on-alpine-linux-docker/44577216#44577216
        coreutils \
        bash \        
# https://github.com/gliderlabs/docker-alpine/issues/292
        wget \
        tar \
        procps \
        # Java Open JDK 8
        openjdk8
                                                                             
# Apache Spark version 2.1.0
ENV SPARKVERSION spark-2.1.0-bin-hadoop2.7

RUN mkdir /opt \
    && wget http://d3kbcqa49mib13.cloudfront.net/${SPARKVERSION}.tgz \
    # Untar Spark, in /opt default to hadoop 2.4 version, and remove extracted file
    && tar -xzf ${SPARKVERSION}.tgz -C /opt/ && rm ${SPARKVERSION}.tgz \   
    # Soft link to version of Spark                                                                          
    && ln -s /opt/${SPARKVERSION} /opt/spark 


# Set up Spark environment
# Options for Standalone Spark Cluster
RUN echo "SPARK_WORKER_MEMORY=2g" >> /opt/spark/conf/spark-env.sh \
    && echo "SPARK_WORKER_INSTANCES=1" >> /opt/spark/conf/spark-env.sh


ADD startTwoNodesCluster.sh /opt/startTwoNodesCluster.sh

RUN chmod +x /opt/startTwoNodesCluster.sh

CMD ["/opt/startTwoNodesCluster.sh"]

