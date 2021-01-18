VERSION=0.0.1
OPERATOR_IMAGE=quay.io/brejohns/vault-helm:$VERSION
BUNDLE_IMAGE=quay.io/brejohns/vault-helm-bundle:$VERSION
INDEX_IMAGE=quay.io/brejohns/vault-helm-index:$VERSION
BUNDLE_CHANNELS=alpha
OPERATOR_NAMESPACE=vault-system
TEST_NAMESPACE=vault-test

oc new-project $OPERATOR_NAMESPACE
oc new-project $TEST_NAMESPACE

make docker-build IMG=$OPERATOR_IMAGE
make docker-push IMG=$OPERATOR_IMAGE

make bundle CHANNELS=$BUNDLE_CHANNELS DEFAULT_CHANNEL=$BUNDLE_CHANNELS VERSION=$VERSION IMG=$OPERATOR_IMAGE

make bundle-build BUNDLE_IMG=$BUNDLE_IMAGE
make docker-push IMG=$BUNDLE_IMAGE

opm index add --bundles $BUNDLE_IMAGE --tag $INDEX_IMAGE --container-tool docker 
docker push $INDEX_IMAGE

operator-sdk run bundle $BUNDLE_IMAGE --index-image=$INDEX_IMAGE --namespace $OPERATOR_NAMESPACE --verbose

rm -rf bundle/*

oc delete project $OPERATOR_NAMESPACE
oc delete project $TEST_NAMESPACE
sleep 15
oc delete crd vaults.vault.sdbrett.com



