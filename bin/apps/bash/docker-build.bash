#!/usr/bin/env bash
# shellcheck disable=2034

#  Script: docker-build.bash
# Purpose: Validate and check information about a provided IP address.
# Created: Mar 20, 2018
#  Author: <B>H</B>ugo <B>S</B>aporetti <B>J</B>unior
#  Mailto: homesetup@gmail.com
# License: Please refer to <https://opensource.org/licenses/MIT>
#
# Copyright (c) 2024, HomeSetup team

# Current script version.
VERSION=2.0.0

# Read folders containing images.
IFS=$'\n'
read -r -d '' -a images < <(find "${HHS_HOME}/docker" -mindepth 1 -type d -exec basename {} \; -print0)
IFS="${OLDIFS}"

USAGE="
Usage: Usage: ${APP_NAME} [Options] image_type

  Options
    -p | --push   : Push the image after a successful build

  Arguments
    - image_type  : The OS to be installed. One of [${images[*]}]
"

# Common application functions
[[ -s "${HHS_DIR}/bin/app-commons.bash" ]] && source "${HHS_DIR}/bin/app-commons.bash"

# We need to load the dotfiles below due to non-interactive shell.
[[ -f "${HOME}"/.bash_commons ]] && source "${HOME}"/.bash_commons


if [[ $# -lt 1 || "${1}" == -h || "${1}" == --help ]]; then
  echo "${USAGE}"
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
          ! docker buildx build --no-cache --progress=plain \
          -t "yorevs/hhs-${next_image}:latest" "${next_image}/"; then
            __hhs_errcho "Failed to build image: \"${next_image}\" !"
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
