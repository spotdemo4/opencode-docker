#! /usr/bin/env nix-shell
#! nix-shell -i fish -p jq skopeo

set opencode_version (
    curl -s https://api.github.com/repos/sst/opencode/releases/latest \
    | jq -r '.tag_name' \
    | string trim --chars=v
)
echo "OpenCode Version: $opencode_version"

set tags (
    skopeo list-tags \
    --creds trev:$token \
    docker://ghcr.io/spotdemo4/opencode \
    | jq -r '.Tags[]' \
    | string split ' '
)
echo "Current Tags: $tags"

for tag in $tags
    if string match -q "$opencode_version" $tag
        echo "Tag $tag already exists, skipping update"
        return 0
    end
end

echo "Tag $opencode_version does not exist, proceeding with update"

echo "Logging in to ghcr.io"
echo "$token" | docker login ghcr.io --username trev --password-stdin

echo "Creating amd64 image"
wget https://github.com/sst/opencode/releases/download/v$opencode_version/opencode-linux-x64.zip
unzip opencode-linux-x64.zip
docker build \
    -t ghcr.io/spotdemo4/opencode:$opencode_version-amd64 \
    --build-arg ARCH=amd64 \
    .
docker push ghcr.io/spotdemo4/opencode:$opencode_version-amd64
rm opencode-linux-x64.zip
rm opencode

echo "Creating arm64 image"
wget https://github.com/sst/opencode/releases/download/v$opencode_version/opencode-linux-arm64.zip
unzip opencode-linux-arm64.zip
docker build \
    -t ghcr.io/spotdemo4/opencode:$opencode_version-arm64 \
    --build-arg ARCH=arm64v8 \
    --platform linux/arm64 \
    .
docker push ghcr.io/spotdemo4/opencode:$opencode_version-arm64
rm opencode-linux-arm64.zip
rm opencode

echo "Creating multi-arch manifest"
docker manifest create ghcr.io/spotdemo4/opencode:$opencode_version \
    --amend ghcr.io/spotdemo4/opencode:$opencode_version-amd64 \
    --amend ghcr.io/spotdemo4/opencode:$opencode_version-arm64
docker manifest annotate \
    ghcr.io/spotdemo4/opencode:$opencode_version \
    ghcr.io/spotdemo4/opencode:$opencode_version-amd64 \
    --arch amd64
docker manifest annotate \
    ghcr.io/spotdemo4/opencode:$opencode_version \
    ghcr.io/spotdemo4/opencode:$opencode_version-arm64 \
    --arch arm64
docker manifest push ghcr.io/spotdemo4/opencode:$opencode_version

echo "Creating multi-arch manifest with latest tag"
docker manifest create ghcr.io/spotdemo4/opencode:latest \
    --amend ghcr.io/spotdemo4/opencode:$opencode_version-amd64 \
    --amend ghcr.io/spotdemo4/opencode:$opencode_version-arm64
docker manifest annotate \
    ghcr.io/spotdemo4/opencode:latest \
    ghcr.io/spotdemo4/opencode:$opencode_version-amd64 \
    --arch amd64
docker manifest annotate \
    ghcr.io/spotdemo4/opencode:latest \
    ghcr.io/spotdemo4/opencode:$opencode_version-arm64 \
    --arch arm64
docker manifest push --purge ghcr.io/spotdemo4/opencode:latest