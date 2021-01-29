CURRENT_VERSION=0.0.2
PREVIOUS_VERSION=0.0.1
OPERATOR_IMAGE=quay.io/brejohns/vault-helm:$CURRENT_VERSION
BUNDLE_IMAGE=quay.io/brejohns/vault-helm-bundle:$CURRENT_VERSION
CURRENT_INDEX_IMAGE=quay.io/brejohns/vault-helm-index:$CURRENT_VERSION
PREVIOUS_VERSION=quay.io/brejohns/vault-helm-index:$PREVIOUS_VERSION
BUNDLE_CHANNELS=alpha
OPERATOR_NAMESPACE=vault-system
TEST_NAMESPACE=vault-test

oc new-project $OPERATOR_NAMESPACE
oc new-project $TEST_NAMESPACE

make docker-build IMG=$OPERATOR_IMAGE
make docker-push IMG=$OPERATOR_IMAGE

make bundle CHANNELS=$BUNDLE_CHANNELS DEFAULT_CHANNEL=$BUNDLE_CHANNELS VERSION=$CURRENT_VERSION IMG=$OPERATOR_IMAGE

make bundle-build BUNDLE_IMG=$BUNDLE_IMAGE
make docker-push IMG=$BUNDLE_IMAGE

opm index add --bundles $BUNDLE_IMAGE --tag $CURRENT_INDEX_IMAGE --container-tool docker --from-index $PREVIOUS_VERSION
docker push $CURRENT_INDEX_IMAGE

operator-sdk run bundle $BUNDLE_IMAGE --index-image=$CURRENT_INDEX_IMAGE --namespace $OPERATOR_NAMESPACE --verbose

rm -rf bundle/*

oc delete project $OPERATOR_NAMESPACE
oc delete project $TEST_NAMESPACE
sleep 15
oc delete crd vaults.vault.sdbrett.com



