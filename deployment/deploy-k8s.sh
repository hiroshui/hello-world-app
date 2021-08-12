#!/bin/bash
set -eu

export APP_NAMESPACE="helloworld"
export DEPLOYMENT_NAME="helloworld-app"
export IMAGE_NAME="hiroshui/java-helloworld"
export IMAGE_TAG="v1.0.0"
export APP_PORT=8080
export REPLICAS=3
export DEPLOYMENT_PATH="k8s"
export CURRENT_FOLDER=$(pwd)
export DEPLOY_FOLDER="${CURRENT_FOLDER}/deploy-tmp"

mkdir -p ${DEPLOY_FOLDER}

echo -e "[INFO]: About to deploy resources in path ${DEPLOYMENT_PATH}."

pushd ${DEPLOYMENT_PATH}

#replace values
for file in $(find * -name "*.yaml"); do
  echo "[Info]: Replace values for file ${file}."
  envsubst < ${file} > ${file}_env
  mv ${file}_env ${DEPLOY_FOLDER}/${file}
done

popd

echo "Check if Namespace ${APP_NAMESPACE} is already created."
ns="kubectl get namespace ${APP_NAMESPACE} --no-headers --output=go-template={{.metadata.name}}"
if ${ns}; then
  echo "[INFO]: Namespace already exist. Will continue with applying all deployments and services."
else
  echo "[INFO]: Namespace (${APP_NAMESPACE}) not found, creating it."
  kubectl create namespace ${APP_NAMESPACE}
fi

pushd ${DEPLOY_FOLDER}

ls

echo "[INFO]: Apply deployment and service for deployment."
if [[ -f deployment.yaml ]]; then
  kubectl -n ${APP_NAMESPACE} apply -f deployment.yaml
fi
if [[ -f service.yaml ]]; then
  kubectl -n ${APP_NAMESPACE} apply -f service.yaml
fi
echo "[INFO]: Applied deployment and service."

kubectl get svc -n ${APP_NAMESPACE} ${DEPLOYMENT_NAME} -o json | jq -r .

popd

rm -rf ${DEPLOY_FOLDER}
