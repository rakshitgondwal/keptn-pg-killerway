# -----------------------------------------#
#        Setting Global variables          #
# -----------------------------------------#
KEPTN_VERSION=0.16.0
JOB_EXECUTOR_SERVICE_VERSION=0.2.0

# ----------------------------------------#
#         Step 1/5: Installing Helm       #
# ----------------------------------------#
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && chmod 700 get_helm.sh
./get_helm.sh

# -----------------------------------------#
#      Step 2/5: Installing Keptn CLI      #
# -----------------------------------------#
curl -sL https://get.keptn.sh | KEPTN_VERSION=$KEPTN_VERSION bash

# -------------------------------------------#
# Step 3/5: Installing Keptn Control Plane #
# -------------------------------------------#
helm install keptn https://github.com/keptn/keptn/releases/download/$KEPTN_VERSION/keptn-$KEPTN_VERSION.tgz -n keptn --wait --timeout=4m --create-namespace --set=control-plane.apiGatewayNginx.type=LoadBalancer

# --------------------------------------------#
# Step 4/5: Installing Job Executor Service #
# --------------------------------------------#
KEPTN_API_TOKEN=$(kubectl get secret keptn-api-token -n keptn -ojsonpath={.data.keptn-api-token} | base64 -d)
helm install --namespace keptn-jes --create-namespace --wait --timeout=2m --set=remoteControlPlane.api.hostname=api-gateway-nginx.keptn --set=remoteControlPlane.api.token=$KEPTN_API_TOKEN --set=remoteControlPlane.topicSubscription="sh.keptn.event.je-deployment.triggered\,sh.keptn.event.je-test.triggered" job-executor-service https://github.com/keptn-contrib/job-executor-service/releases/download/$JOB_EXECUTOR_SERVICE_VERSION/job-executor-service-$JOB_EXECUTOR_SERVICE_VERSION.tgz

#------------------------------------------#
#       🎉 Installation Complete 🎉        #
#           Please proceed now...           #
# ------------------------------------------#
