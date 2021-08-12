#!/bin/bash
set -eu

export APP_NAME="hello-world"
export APP_PORT=8080
export IMAGE_NAME="hiroshui/java-helloworld"
export IMAGE_TAG="v1.0.0"
export BUILD_PATH="image"
export SOURCE_PATH="hello-world-app"

CURRENT_FOLDER=$(pwd)
BUILD_FOLDER=${CURRENT_FOLDER}/"build-folder"
ARTIFACT_PATH=${BUILD_FOLDER}/${APP_NAME}.jar

mkdir -p ${BUILD_FOLDER}

pushd ${BUILD_PATH}
# envsubst for all files
for file in $(find . -type f -name "*"); do
  envsubst < "${file}" > "${file}.env"
  mv "${file}.env" ${BUILD_FOLDER}/"${file}"
done
popd

echo -e "[INFO]: Build jar-artifact with maven in path ${BUILD_PATH}."

pushd ${SOURCE_PATH}
mvn clean package
popd

cp ${SOURCE_PATH}/target/*.jar ${ARTIFACT_PATH}

pushd ${BUILD_FOLDER}

docker login -u hiroshui

docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
docker push ${IMAGE_NAME}:${IMAGE_TAG}

popd

#cleanup
rm -rf ${BUILD_FOLDER}
