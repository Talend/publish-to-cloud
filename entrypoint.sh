#!/bin/sh -l

# Add Java home to the path
export PATH=$PATH:$JAVA_HOME/bin

# Decrypt the license file
mkdir $HOME/secrets
gpg --quiet --batch --yes --decrypt --passphrase="${INPUT_LICENSE_PASSPHRASE}" \
--output $HOME/secrets/license "${INPUT_LICENSE_PATH}"

echo "Hello Talend user, thank you for using this Github Action"
echo "You selected ${INPUT_PROJECT} project"

# Set maven options
export MAVEN_OPTS="-Dlicense.path=${HOME}/secrets/license \
                   -Dupdatesite.path=${INPUT_UPDATESITE_PATH} \
                   -Dservice.url=${INPUT_SERVICE_URL} \
                   -Dservice.accelerate=${INPUT_SERVICE_ACCELERATE} \
                   -Dcloud.token=${INPUT_CLOUD_TOKEN} \
                   -Dcloud.publisher.screenshot=${INPUT_CLOUD_PUBLISHER_SCREENSHOT} \
                   -Dcloud.publisher.skip=${INPUT_CLOUD_PUBLISHER_SKIP} \
                   -Dcloud.publisher.updateFlow=${INPUT_CLOUD_PUBLISHER_UPDATEFLOW} \
                   -Dcloud.publisher.environment=${INPUT_CLOUD_PUBLISHER_ENVIRONMENT} \
                   -Dcloud.publisher.workspace=${INPUT_CLOUD_PUBLISHER_WORKSPACE}"

# Maven command
sh -c "mvn -s /maven-settings.xml \
           -f ${GITHUB_WORKSPACE}/${INPUT_PROJECT}/poms/pom.xml \
           -Pcloud-publisher clean deploy $*"