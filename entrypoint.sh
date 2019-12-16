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
                   -Dupdatesite.path=${INPUT_P2_URL} \
                   -Dservice.url=${INPUT_CLOUD_URL} \
                   -Dcloud.token=${INPUT_CLOUD_TOKEN} \
                   -Dcloud.publisher.screenshot=${INPUT_SCREENSHOT}"

# Maven command
sh -c "mvn -s /maven-settings.xml \
           -f ${GITHUB_WORKSPACE}/${INPUT_PROJECT}/poms/pom.xml \
           -Pcloud-publisher clean deploy $*"