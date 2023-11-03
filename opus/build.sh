#!/bin/bash

WORK_DIR=`pwd`
FRAMEWORK_NAME=opus
RELEASE_DIR=$WORK_DIR/build/dist
POD_NAME=${FRAMEWORK_NAME}.xcframework
VERSION=0.0.0.1

PUBLISH_BUILD=1
RUN_TESTS_ONLY=0

OPTION_RELEASE='release'
PACKAGE_NAME=${POD_NAME}.zip

# ./build_framework.sh
pushd $RELEASE_DIR
while true; do
        zip -ry "${PACKAGE_NAME}" "${POD_NAME}"
        if [ $? -ne 0 ]; then break; fi

        local ARHIVE_DIR_NAME=$(basename "$XC_BUILD_ARCHIVES_ROOT")
        zip -ry "${ARHIVE_PACK_NAME}" "${ARHIVE_DIR_NAME}"
        if [ $? -ne 0 ]; then break; fi
        
        break
done

popd

# =================================================================
#
# =================================================================
if [ 0 -eq $PUBLISH_BUILD ]; then
    echo 'Skip build publishing'
    exit 0
fi

# =================================================================
# Upload to jfrog
# =================================================================
echo "Uploading ${RELEASE_DIR}/${PACKAGE_NAME} to public repository ..."

curl -H "X-JFrog-Art-Api:AKCp8ihpQm2FCR5T2WPsjx9hdCBwo9h9S9twY472mJjXTmjTCAahZVB745KA2SJCmdm5hzS8S" \
    -XPUT https://nativevoiceai.jfrog.io/artifactory/CocoaPods/ai/nativevoice/${FRAMEWORK_NAME}/${VERSION}/ \
    -T ${RELEASE_DIR}/${PACKAGE_NAME}

if [ $? -ne 0 ]; then
    echo "Failed uploading ${PACKAGE_NAME}"
    exit 3
fi


# =================================================================
# Publish spec
# =================================================================
echo "Publishing POD spec ..."
# backup current pod spec first
POD_SPEC="${FRAMEWORK_NAME}.podspec"
POD_SPEC_BACKUP="${FRAMEWORK_NAME}.podspec.backup"
if [ -f "$POD_SPEC" ]; then
    cat "$POD_SPEC" > "$POD_SPEC_BACKUP"
fi

sed -e "s/#VERSION#/${VERSION}/g" ${FRAMEWORK_NAME}.podspec.template > "$POD_SPEC"
RESULT=$?
if [ $RESULT -ne 0 ]; then
    echo "Creating podspec failed"
else
    ./publish.sh
    RESULT=$?
fi

# try to restore original pod spec
if [ -f "$POD_SPEC_BACKUP" ]; then
    cat "$POD_SPEC_BACKUP" > "$POD_SPEC"
    rm -f "$POD_SPEC_BACKUP"
fi

if [ $RESULT -ne 0 ]; then
    echo "Failed"
    exit 1
fi

echo "Complete"
