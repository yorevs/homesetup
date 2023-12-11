#!/bin/bash

# We need to load the dotfiles below due to non-interactive shell.
[[ -f "${HOME}"/.bash_commons ]] && source "${HOME}"/.bash_commons

IFS=$'\n' read -r -d '' -a images < <(find "${HHS_HOME}/docker" -type d -mindepth 1 -exec basename {} \;)
IFS="${OLDIFS}"

if [[ $# -lt 1 || "${1}" == -h || "${1}" == --help ]]; then
  echo "Usage: docker-build.sh [-p|--push] <image_type...>"
  echo ''
  echo '  Options'
  echo '    -p | --push   : Push the image after a successful build'
  echo ''
  echo '  Arguments'
  echo "    - image_type  : The OS to be installed. One of [${images[*]}]"
  exit 1
else
  [[ "${1}" == "-p" || "${1}" == "--push" ]] && push_image=1 && shift
  for next_image in "${@}"; do
    # shellcheck disable=SC2199
    if [[ ${images[@]} =~ ${next_image} ]]; then
      [[ -d "${next_image}/" ]] || __hhs_errcho "Unable to find directory: ${next_image}/"
      echo ''
      echo -e "${PURPLE}Building ${BLUE}[${next_image}] ... ${NC}"
      echo ''
      # Docker build tag: ${IMAGE_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}
      if [[ -d "${next_image}/" ]] && \
          ! docker build --no-cache --progress plain -t "yorevs/hhs-${next_image}:latest" "${next_image}/"; then
            __hhs_errcho "Failed to build image: \"${next_image}\" !"
            exit 1
        exit 1
      elif [[ -n ${push_image} ]]; then
        if ! docker push "yorevs/hhs-${next_image}:latest"; then
          __hhs_errcho "Failed to push image: \"${next_image}\" !"
          exit 1
        fi
      fi

    else
      __hhs_errcho "Invalid container type: \"${next_image}\". Please use one of [${images[*]}] !"
      exit 1
    fi
  done
fi

exit 0
