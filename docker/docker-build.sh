#!/bin/bash

if [[ $# -lt 1 || "${1}" == -h || "${1}" == --help ]]; then
  echo "Usage: docker-build.sh [-p|--push] <image_type...>"
  echo ''
  echo '  Options'
  echo '    -p | --push   : Push the image after a successful build'
  echo ''
  echo '  Arguments'
  echo '    - image_type  : The OS to be installed. One of [ubuntu|centos|fedora|alpine]'
  exit 1
else
  [[ "${1}" == "-p" || "${1}" == "--push" ]] && push_image=1 && shift
  images="$(find . -type d -mindepth 1 | tr '\n' ' ')"
  images="${images//\.\//}"
  for next_image in "${@}"; do
    if [[ "${images}" == *"${next_image}"* ]]; then
      [[ -d "${next_image}/" ]] || echo -e "${RED}Unable to find directory: ${next_image}/${NC}"
      echo ''
      echo -e "${PURPLE}Building ${BLUE}[${next_image}] ... ${NC}"
      echo ''
      # Docker build tag: ${IMAGE_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}
      if [[ -d "${next_image}/" ]] && \
          ! docker build --no-cache --progress plain -t "yorevs/hhs-${next_image}:latest" "${next_image}/"; then
            echo "${RED}Failed to build image: \"${next_image}\" !${NC}"
            exit 1
        exit 1
      elif [[ -n ${push_image} ]]; then
        if ! docker push "yorevs/hhs-${next_image}:latest"; then
          echo "${RED}Failed to push image: \"${next_image}\" !${NC}"
          exit 1
        fi
      fi

    else
      echo "${RED}Invalid container type: \"${next_image}\". Please use one of [${images}] ! ${NC}"
      exit 1
    fi
  done
fi

exit 0
